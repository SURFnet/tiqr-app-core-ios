import UIKit
import AppAuth

public class AppAuthController: NSObject {
    
    //MARK: - singleton
    public static var shared = AppAuthController()
    
    //MARK: - properties of AppAuth
    private var currentAuthorizationFlow: OIDExternalUserAgentSession?
    private let keychain = KeyChainService()
    var authState: OIDAuthState!
    var request: OIDAuthorizationRequest!
    var tokenRefreshRequest: OIDTokenRequest {
        let config = OIDServiceConfiguration(
            authorizationEndpoint: URL(string: AppAuthController.authEndpointString)!,
            tokenEndpoint: URL(string: AppAuthController.tokenEndpointString)!
        )
        
        let codeVerifier = OIDAuthorizationRequest.generateCodeVerifier()
        
        return OIDTokenRequest(
            configuration: config,
            grantType: OIDGrantTypeRefreshToken,
            authorizationCode: nil,
            redirectURL: URL(string: AppAuthController.redirectURIString),
            clientID: AppAuthController.clientID,
            clientSecret: nil,
            scope: "eduid.nl/mobile",
            refreshToken: refreshToken,
            codeVerifier: codeVerifier,
            additionalParameters: nil
        )
    }
    
    //MARK: - tokens
    var accessToken: String = ""
    var refreshToken: String = ""
    
    //MARK: - URI's
    static let authEndpointString = "https://connect.test2.surfconext.nl/oidc/authorize"
    static let tokenEndpointString = "https://connect.test2.surfconext.nl/oidc/token"
    static let redirectURIString = "https://login.test2.eduid.nl/client/mobile/oauth-redirect"
    public static let clientID = "dev.egeniq.nl"
    
    //MARK: - init
    private override init() {
        super.init()
        
        let config = OIDServiceConfiguration(
            authorizationEndpoint: URL(string: AppAuthController.authEndpointString)!,
            tokenEndpoint: URL(string: AppAuthController.tokenEndpointString)!
        )
        
        let codeVerifier = OIDAuthorizationRequest.generateCodeVerifier()
        let codeChallenge = OIDAuthorizationRequest.codeChallengeS256(forVerifier: codeVerifier)
        
        request = OIDAuthorizationRequest(
            configuration: config,
            clientId: AppAuthController.clientID,
            clientSecret: nil,
            scope: "eduid.nl/mobile",
            redirectURL: URL(string: AppAuthController.redirectURIString)!,
            responseType: OIDResponseTypeCode,
            state: UUID().uuidString,
            nonce: UUID().uuidString,
            codeVerifier: codeVerifier,
            codeChallenge: codeChallenge,
            codeChallengeMethod: OIDOAuthorizationRequestCodeChallengeMethodS256,
            additionalParameters: nil
        )
        
    }
    
    public func isRedirectURI(_ uri: URL) -> Bool {
        let expectedRedirectPath = URLComponents(string: AppAuthController.redirectURIString)?.path
        let inputPath = URLComponents(string: uri.absoluteString)?.path
        return expectedRedirectPath != nil &&
            inputPath != nil &&
            inputPath!.caseInsensitiveCompare(expectedRedirectPath!) == .orderedSame
    }
    
    public func tryResumeAuthorizationFlow(with uri: URL) -> Bool {
        if let authFlow = currentAuthorizationFlow,
           isRedirectURI(uri) {
            // Normalize URL, because it might be a custom scheme one
            currentAuthorizationFlow = nil
            guard var normalizedUrl = URLComponents(string: uri.absoluteString) else {
                return false
            }
            if normalizedUrl.scheme == "eduid" {
                let expectedUrlComponents = URLComponents(string: AppAuthController.redirectURIString)!
                normalizedUrl.scheme = expectedUrlComponents.scheme
                normalizedUrl.host = expectedUrlComponents.host
            }
            return authFlow.resumeExternalUserAgentFlow(with: normalizedUrl.url!)
        } else {
            currentAuthorizationFlow = nil
            return false
        }
    }
    
    public func authorize(viewController: UIViewController, completion: (() -> Void)? = nil) {
        let externalUserAgent = OIDExternalUserAgentIOSSafari(presentingViewController: viewController)
        currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, externalUserAgent: externalUserAgent) { [weak self] authState, error in
            guard let self else { return }
            if let authState = authState {
                self.authState = authState
                if let newAccessToken = authState.lastTokenResponse?.accessToken {
                    self.keychain.set("Bearer " + newAccessToken, for: Constants.KeyChain.accessToken)
                    if let newRefreshToken = authState.lastTokenResponse?.refreshToken {
                        self.keychain.set(newRefreshToken, for: Constants.KeyChain.refreshToken)
                    }
                    completion?()
                }
            } else {
                fatalError("authorization failed")
            }
        }
    }
    
}
