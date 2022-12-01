/*
 * Copyright (c) 2010-2011 SURFnet bv
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of SURFnet bv nor the names of its contributors 
 *    may be used to endorse or promote products derived from this 
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
 * IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
 * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "AuthenticationConfirmationRequest.h"
#import "NotificationRegistration.h"
#import "TiqrConfig.h"
@import TiqrCore;

NSString *const TIQRACRErrorDomain = @"org.tiqr.acr";
NSString *const TIQRACRAttemptsLeftErrorKey = @"AttempsLeftErrorKey";

typedef void (^CompletionBlock)(BOOL success, NSError *error);

@interface AuthenticationConfirmationRequest ()

@property (nonatomic, strong) AuthenticationChallenge *challenge;
@property (nonatomic, copy) NSString *response;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, copy) NSString *protocolVersion;
@property (nonatomic, strong) NSURLConnection *sendConnection;
@property (nonatomic, strong) CompletionBlock completionBlock;

@end

@implementation AuthenticationConfirmationRequest

- (instancetype)initWithAuthenticationChallenge:(AuthenticationChallenge *)challenge response:(NSString *)response {
    self = [super init];
    if (self != nil) {
        self.challenge = challenge;
        self.response = response;
    }
    
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.data setLength:0];
    
    NSDictionary* headers = [(NSHTTPURLResponse *)response allHeaderFields];
    if (headers[@"X-TIQR-Protocol-Version"]) {
        self.protocolVersion = headers[@"X-TIQR-Protocol-Version"];
    } else {
        self.protocolVersion = @"1";
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)connectionError {
    self.data = nil;
    
    NSString *title = [Localization localize:@"no_connection" comment:@"No connection error title"];
    NSString *message = [Localization localize:@"no_active_internet_connection." comment:@"You appear to have no active Internet connection."];
    NSMutableDictionary *details = [NSMutableDictionary dictionary];
    [details setValue:title forKey:NSLocalizedDescriptionKey];
    [details setValue:message forKey:NSLocalizedFailureReasonErrorKey];    
    [details setValue:connectionError forKey:NSUnderlyingErrorKey];
    
    NSError *error = [NSError errorWithDomain:TIQRACRErrorDomain code:TIQRACRConnectionError userInfo:details];
    self.completionBlock(NO, error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

    if (self.protocolVersion != nil && [self.protocolVersion intValue] > 1) {
        // Parse JSON result
        id result = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:nil];
        self.data = nil;
        
        NSNumber *responseCode = @([[result valueForKey:@"responseCode"] intValue]);
        if ([responseCode intValue] == AuthenticationChallengeResponseCodeSuccess) {
            self.completionBlock(YES, nil);
        } else {
            NSInteger code = TIQRACRUnknownError;
            NSString *title = [Localization localize:@"unknown_error" comment:@"Unknown error title"];
            NSString *message = [NSString stringWithFormat:[Localization localize:@"error_auth_unknown_error" comment:@"Unknown error message"], TiqrConfig.appName];
            NSNumber *attemptsLeft = nil;
            
            switch ([responseCode intValue]) {
                case AuthenticationChallengeResponseCodeAccountBlocked: {
                    if ([result valueForKey:@"duration"] != nil) {
                        NSNumber *duration = @([[result valueForKey:@"duration"] intValue]);
                        code = TIQRACRAccountBlockedErrorTemporary;
                        title = [Localization localize:@"error_auth_account_blocked_temporary_title" comment:@"INVALID_RESPONSE error title (account blocked temporary)"];
                        message = [NSString stringWithFormat:[Localization localize:@"error_auth_account_blocked_temporary_message" comment:@"INVALID_RESPONSE error message (account blocked temporary"], duration];
                    } else {
                        code = TIQRACRAccountBlockedError;
                        title = [Localization localize:@"error_auth_account_blocked_title" comment:@"INVALID_RESPONSE error title (0 attempts left)"];
                        message = [Localization localize:@"error_auth_account_blocked_message" comment:@"INVALID_RESPONSE error message (0 attempts left)"];
                    }
                } break;
                    
                case AuthenticationChallengeResponseCodeInvalidChallenge: {
                    code = TIQRACRInvalidChallengeError;
                    title = [Localization localize:@"error_auth_invalid_challenge_title" comment:@"INVALID_CHALLENGE error title"];
                    message = [Localization localize:@"error_auth_invalid_challenge_message" comment:@"INVALID_CHALLENGE error message"];
                } break;
                    
                case AuthenticationChallengeResponseCodeInvalidRequest: {
                    code = TIQRACRInvalidRequestError;
                    title = [Localization localize:@"error_auth_invalid_request_title" comment:@"INVALID_REQUEST error title"];
                    message = [Localization localize:@"error_auth_invalid_request_message" comment:@"INVALID_REQUEST error message"];
                } break;
                    
                case AuthenticationChallengeResponseCodeInvalidUsernamePasswordPin: {                    code = TIQRACRInvalidResponseError;
                    if ([result valueForKey:@"attemptsLeft"] != nil) {
                        attemptsLeft = @([[result valueForKey:@"attemptsLeft"] intValue]);
                        if ([attemptsLeft intValue] > 1) {
                            title = [Localization localize:@"error_auth_wrong_pin" comment:@"INVALID_RESPONSE error title (> 1 attempts left)"];
                            message = [Localization localize:@"error_auth_x_attempts_left" comment:@"INVALID_RESPONSE error message (> 1 attempts left)"];
                            message = [NSString stringWithFormat:message, [attemptsLeft intValue]];
                        } else if ([attemptsLeft intValue] == 1) {
                            title = [Localization localize:@"error_auth_wrong_pin" comment:@"INVALID_RESPONSE error title (1 attempt left)"];
                            message = [Localization localize:@"error_auth_one_attempt_left" comment:@"INVALID_RESPONSE error message (1 attempt left)"];
                        } else {
                            title = [Localization localize:@"error_auth_account_blocked_title" comment:@"INVALID_RESPONSE error title (0 attempts left)"];
                            message = [Localization localize:@"error_auth_account_blocked_message" comment:@"INVALID_RESPONSE error message (0 attempts left)"];
                        }
                    } else {
                        title = [Localization localize:@"error_auth_wrong_pin" comment:@"INVALID_RESPONSE error title (infinite attempts left)"];
                        message = [Localization localize:@"error_auth_infinite_attempts_left" comment:@"INVALID_RESPONSE erorr message (infinite attempts left)"];
                    }
                } break;
                
                case AuthenticationChallengeResponseCodeInvalidUser: {
                    code = TIQRACRInvalidUserError;
                    title = [Localization localize:@"error_auth_invalid_account" comment:@"INVALID_USERID error title"];
                    message = [Localization localize:@"error_auth_invalid_account_message" comment:@"INVALID_USERID error message"];
                } break;
                    
                default: {
                    code = TIQRACUnknownError;
                    title = [Localization localize:@"error_auth_unknown_reponsecode" comment:@"UNKNOWN_RESPONSE_CODE error title"];
                    message = [NSString stringWithFormat:[Localization localize:@"error_auth_unknown_reponsecode_message" comment:@"UNKNOWN_RESPONSE_CODE error message"], TiqrConfig.appName];
                }
            }
            
            NSString *serverMessage = [result valueForKey:@"message"];
            if (serverMessage) {
                message = serverMessage;
            }
            
            NSMutableDictionary *details = [NSMutableDictionary dictionary];
            [details setValue:title forKey:NSLocalizedDescriptionKey];
            [details setValue:message forKey:NSLocalizedFailureReasonErrorKey];
            if (attemptsLeft != nil) {
                [details setValue:attemptsLeft forKey:TIQRACRAttemptsLeftErrorKey];
            }
            
            NSError *error = [NSError errorWithDomain:TIQRACRErrorDomain code:code userInfo:details];
            self.completionBlock(NO, error);
        }
    } else {
        // Parse String result
        NSString *response = [[NSString alloc] initWithBytes:[self.data bytes] length:[self.data length] encoding:NSUTF8StringEncoding];
        if ([response isEqualToString:@"OK"]) {
            self.completionBlock(YES, nil);
        } else {
            NSInteger code = TIQRACRUnknownError;
            NSString *title = [Localization localize:@"unknown_error" comment:@"Unknown error title"];
            NSString *message = [NSString stringWithFormat:[Localization localize:@"error_auth_unknown_error" comment:@"Unknown error message"], TiqrConfig.appName];
            NSNumber *attemptsLeft = nil;
            if ([response isEqualToString:@"ACCOUNT_BLOCKED"]) {
                code = TIQRACRAccountBlockedError;
                title = [Localization localize:@"error_auth_account_blocked_title" comment:@"INVALID_RESPONSE error title (0 attempts left)"];
                message = [Localization localize:@"error_auth_account_blocked_message" comment:@"INVALID_RESPONSE error message (0 attempts left)"];
            } else if ([response isEqualToString:@"INVALID_CHALLENGE"]) {
                code = TIQRACRInvalidChallengeError;
                title = [Localization localize:@"error_auth_invalid_challenge_title" comment:@"INVALID_CHALLENGE error title"];
                message = [Localization localize:@"error_auth_invalid_challenge_message" comment:@"INVALID_CHALLENGE error message"];
            } else if ([response isEqualToString:@"INVALID_REQUEST"]) {
                code = TIQRACRInvalidRequestError;
                title = [Localization localize:@"error_auth_invalid_request_title" comment:@"INVALID_REQUEST error title"];
                message = [Localization localize:@"error_auth_invalid_request_message" comment:@"INVALID_REQUEST error message"];
            } else if ([response isEqualToString:@"INVALID_RESPONSE"]) {
                code = TIQRACRInvalidResponseError;
                title = [Localization localize:@"error_auth_wrong_pin" comment:@"INVALID_RESPONSE error title (infinite attempts left)"];
                message = [Localization localize:@"error_auth_infinite_attempts_left" comment:@"INVALID_RESPONSE error message (infinite attempts left)"];
            } else if ([response length]>=17 && [[response substringToIndex:17] isEqualToString:@"INVALID_RESPONSE:"]) {
                attemptsLeft = @([[response substringFromIndex:17] intValue]);
                code = TIQRACRInvalidResponseError;
                if ([attemptsLeft intValue] > 1) {
                    title = [Localization localize:@"error_auth_wrong_pin" comment:@"INVALID_RESPONSE error title (> 1 attempts left)"];
                    message = [Localization localize:@"error_auth_x_attempts_left" comment:@"INVALID_RESPONSE error message (> 1 attempts left)"];
                    message = [NSString stringWithFormat:message, [attemptsLeft intValue]];
                } else if ([attemptsLeft intValue] == 1) {
                    title = [Localization localize:@"error_auth_wrong_pin" comment:@"INVALID_RESPONSE error title (1 attempt left)"];
                    message = [Localization localize:@"error_auth_one_attempt_left" comment:@"INVALID_RESPONSE error message (1 attempt left)"];
                } else {
                    title = [Localization localize:@"error_auth_account_blocked_title" comment:@"INVALID_RESPONSE error title (0 attempts left)"];
                    message = [Localization localize:@"error_auth_account_blocked_message" comment:@"INVALID_RESPONSE error message (0 attempts left)"];
                }
            } else if ([response isEqualToString:@"INVALID_USERID"]) {
                code = TIQRACRInvalidUserError;
                title = [Localization localize:@"error_auth_invalid_account" comment:@"INVALID_USERID error title"];
                message = [Localization localize:@"error_auth_invalid_account_message" comment:@"INVALID_USERID error message"];
            }
            
            NSMutableDictionary *details = [NSMutableDictionary dictionary];
            [details setValue:title forKey:NSLocalizedDescriptionKey];
            [details setValue:message forKey:NSLocalizedFailureReasonErrorKey];
            if (attemptsLeft != nil) {
                [details setValue:attemptsLeft forKey:TIQRACRAttemptsLeftErrorKey];
            }
            
            NSError *error = [NSError errorWithDomain:TIQRACRErrorDomain code:code userInfo:details];
            self.completionBlock(NO, error);
        }
    }
    
}

- (void)sendWithCompletionHandler:(void(^)(BOOL success, NSError *error))completionHandler {
    self.completionBlock = completionHandler;
    
	NSString *escapedSessionKey = [self.challenge.sessionKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *escapedUserId = [self.challenge.identity.identifier stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *escapedResponse = [self.response stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *escapedLanguage = [NSLocale preferredLanguages][0];
	NSString *notificationToken = [NotificationRegistration sharedInstance].notificationToken;
	NSString *escapedNotificationToken = [notificationToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *operation = @"login";
    NSString *version = TiqrConfig.protocolVersion;
    NSString *notificationType = [NotificationRegistration sharedInstance].notificationType;
    NSString *escapedNotificationType = [notificationType stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

	NSString *body = [NSString stringWithFormat:@"sessionKey=%@&userId=%@&response=%@&language=%@&notificationType=%@&notificationAddress=%@&operation=%@&version=%@", escapedSessionKey, escapedUserId, escapedResponse, escapedLanguage, escapedNotificationType, escapedNotificationToken, operation, version];
        
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.challenge.identityProvider.authenticationUrl]];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request setTimeoutInterval:5.0];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[TiqrUserAgent getUserAgent] forHTTPHeaderField:@"User-Agent"];
    [request setValue:version forHTTPHeaderField:@"X-TIQR-Protocol-Version"];
    
    self.data = [NSMutableData data];
	self.sendConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


@end
