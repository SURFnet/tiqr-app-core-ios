/**
 * Based on ZXingWidgetController.
 *
 * Copyright 2009 Jeff Verkoeyen
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "ScanViewController.h"
#import "ScanOverlayView.h"
#import "AuthenticationChallenge.h"
#import "EnrollmentChallenge.h"
#import "AuthenticationIdentityViewController.h"
#import "AuthenticationConfirmViewController.h"
#import "AuthenticationFallbackViewController.h"
#import "EnrollmentConfirmViewController.h"
#import "IdentityListViewController.h"
#import "ErrorViewController.h"
#import "External/MBProgressHUD.h"
#import "ServiceContainer.h"
#import "TiqrConfig.h"
@import TiqrCore;

@interface ScanViewController () <AVAudioPlayerDelegate, AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>

#if HAS_AVFF
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
#endif

@property (nonatomic) dispatch_queue_t sessionQueue;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, assign, getter=isDecoding) BOOL decoding;
@property (nonatomic, strong) UIBarButtonItem *identitiesButtonItem;

@property (nonatomic, strong) IBOutlet UILabel *instructionLabel;

@property (nonatomic, strong) IBOutlet UIView *previewView;
@property (nonatomic, strong) IBOutlet ScanOverlayView *overlayView;
@property (nonatomic, strong) IBOutlet UIView *instructionsView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *instructionsViewBottomConstraint;

@end

@implementation ScanViewController

- (instancetype)init {
    self = [super initWithNibName:@"ScanView" bundle:SWIFTPM_MODULE_BUNDLE];
    if (self) {
        self.decoding = NO;
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        NSString *filePath = [SWIFTPM_MODULE_BUNDLE pathForResource:@"cowbell" ofType:@"wav"];

        NSURL *fileURL = [NSURL fileURLWithPath:filePath isDirectory:NO];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];

        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        [self.audioPlayer prepareToPlay];
        self.audioPlayer.delegate = self;

        UIImage *image = [UIImage imageNamed:@"identities-icon" inBundle:SWIFTPM_MODULE_BUNDLE compatibleWithTraitCollection:nil];
        self.identitiesButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(listIdentities)];
        self.navigationItem.rightBarButtonItem = self.identitiesButtonItem;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.overlayView.points = nil;
    
    self.instructionsView.alpha = 0.0;
    
    if (ServiceContainer.sharedInstance.identityService.identityCount > 0) {
        self.navigationItem.rightBarButtonItem = self.identitiesButtonItem;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.instructionLabel.text = [Localization localize:@"msg_default_status" comment:@"QR Code scan instruction"];
    
    // Communicate with the session and other session objects on this queue.
    self.sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.decoding = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.instructionsView.alpha = 0.7;
    [UIView commitAnimations];
    
    [self startCameraIfAllowed];
}

- (void)startCameraIfAllowed {
    
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusNotDetermined:
            [self promptForCameraAccess];
            break;
            
        case AVAuthorizationStatusAuthorized:
            [self initCapture];
            break;
            
        default:
            [self promptForCameraSettings];
            break;
    }
}

- (void)promptForCameraAccess {
    dispatch_suspend(self.sessionQueue);
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_resume(self.sessionQueue);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startCameraIfAllowed];
        });
    }];
}

- (void)promptForCameraSettings {
    NSString *buttonTitle = [Localization localize:@"settings_app_name" comment:@"Name of the settings app"];
    NSString *string = [Localization localize:@"camera_prompt_title" comment:@"Camera access prompt title"];
    NSString *message = [NSString stringWithFormat:[Localization localize:@"camera_prompt_message" comment:@"Camera access prompt message"], TiqrConfig.appName, TiqrConfig.appName];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:string message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];

    [alertController addAction: okButton];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.instructionsView.alpha = 0.0;
    
    [self stopCapture];
}

#pragma mark -
#pragma mark AlertView delegate

#pragma mark -
#pragma mark Decoder delegates

- (void)processMetadataObject:(AVMetadataMachineReadableCodeObject *)metadataObject {
    
#if HAS_AVFF
    dispatch_async(self.sessionQueue, ^{
        [self.captureSession stopRunning];
    });
#endif
    
    NSMutableArray *points = [NSMutableArray array];
    for (NSDictionary *corner in metadataObject.corners)  {
        CGPoint point;
        CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)corner, &point);
        [points addObject:[NSValue valueWithCGPoint:point]];
    }
    
    self.overlayView.points = points;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    self.instructionsView.alpha = 0.0;
    [UIView commitAnimations];
    
    // now, in a selector, call the delegate to give this overlay time to show the points
    [self performSelector:@selector(processChallenge:) withObject:metadataObject.stringValue afterDelay:1.0];
    [self.audioPlayer play];
}

#pragma mark -
#pragma mark AVFoundation

- (void)initCapture {
#if HAS_AVFF
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetMedium;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    if ([self.captureSession canAddInput:captureInput]) {
        [self.captureSession addInput:captureInput];
    }
    
    AVCaptureMetadataOutput *captureOutput = [[AVCaptureMetadataOutput alloc] init];
    if ([self.captureSession canAddOutput:captureOutput]) {
        [self.captureSession addOutput:captureOutput];
    }
    
    [captureOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    captureOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.previewLayer.frame = self.view.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.previewView.layer addSublayer:self.previewLayer];
    
    dispatch_async(self.sessionQueue, ^{
        [self.captureSession startRunning];
    });
#endif
}

#if HAS_AVFF
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if ([metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        AVMetadataMachineReadableCodeObject *transformedMetadataObject = (AVMetadataMachineReadableCodeObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:metadataObject];
        [self processMetadataObject:transformedMetadataObject];
    }
}
#endif

- (void)stopCapture {
    self.decoding = NO;
    
#if HAS_AVFF
    AVCaptureSession *currentCaptureSession = self.captureSession;
    dispatch_async(self.sessionQueue, ^{
        [currentCaptureSession stopRunning];

        if ([currentCaptureSession.inputs count]) {
            AVCaptureInput* input = [currentCaptureSession.inputs objectAtIndex:0];
            [currentCaptureSession removeInput:input];
        }
        
        if ([currentCaptureSession.outputs count]) {
            AVCaptureVideoDataOutput* output = (AVCaptureVideoDataOutput *)[currentCaptureSession.outputs objectAtIndex:0];
            [currentCaptureSession removeOutput:output];
        }
    });
    
    [self.previewLayer removeFromSuperlayer];
    self.previewLayer = nil;
    self.captureSession = nil;
#endif
}


- (void)pushViewControllerForChallenge:(NSObject *)challenge Type:(TIQRChallengeType) type {
    UIViewController *viewController = nil;
    
    switch (type) {
        case TIQRChallengeTypeAuthentication: {
            AuthenticationChallenge *authenticationChallenge = (AuthenticationChallenge *)challenge;
            if (authenticationChallenge.identity == nil) {
                AuthenticationIdentityViewController *identityViewController = [[AuthenticationIdentityViewController alloc] initWithAuthenticationChallenge:authenticationChallenge];
                viewController = identityViewController;
            } else {
                AuthenticationConfirmViewController *confirmViewController = [[AuthenticationConfirmViewController alloc] initWithAuthenticationChallenge:authenticationChallenge];
                viewController = confirmViewController;
            }
        } break;
            
        case TIQRChallengeTypeEnrollment: {
            EnrollmentConfirmViewController *confirmViewController = [[EnrollmentConfirmViewController alloc] initWithEnrollmentChallenge:(EnrollmentChallenge *)challenge];
            viewController = confirmViewController;
        }
            
        default:
            break;
    }
    
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)processChallenge:(NSString *)scanResult {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [ServiceContainer.sharedInstance.challengeService startChallengeFromScanResult:scanResult completionHandler:^(TIQRChallengeType type, NSObject * _Nullable challengeObject, NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
        if (type != TIQRChallengeTypeInvalid) {
            [self pushViewControllerForChallenge:challengeObject Type:type];
        } else {
            ErrorViewController *viewController = [[ErrorViewController alloc] initWithErrorTitle:error.localizedDescription errorMessage:error.localizedFailureReason];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
    }];
}

- (void)listIdentities {
    IdentityListViewController *viewController = [[IdentityListViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
