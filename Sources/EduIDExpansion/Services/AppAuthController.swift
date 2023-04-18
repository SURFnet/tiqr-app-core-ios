import UIKit
import AppAuth


public class AppAuthController {
    
    //MARK: - signleton
//    public static var shared = AppAuthController()
    private let keychain = KeyChainService()
    static var sceneDelegate: MySceneDelegateProtocol? {
        didSet {
            print("sceneDelegate: \(sceneDelegate)")
        }
    }
    
    //MARK: - properties of AppAuth
    public var currentAuthorizationFlow: OIDExternalUserAgentSession?
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
    var accessToken: String {
        
        get {
            return keychain.getString(for: Constants.KeyChain.accessToken)
        } set(newAccessToken) {
            keychain.set(newAccessToken, for: Constants.KeyChain.accessToken)
        }
    }
    var refreshToken: String = ""
    
    //MARK: - URI's
    static let authEndpointString = "https://connect.test2.surfconext.nl/oidc/authorize"
    static let tokenEndpointString = "https://connect.test2.surfconext.nl/oidc/token"
    static let redirectURIString = "https://login.test2.eduid.nl/client/mobile/oauth-redirect"
    public static let clientID = "dev.egeniq.nl"
    

    public convenience init(sceneDelegate: MySceneDelegateProtocol? = nil) {
        self.init()
        AppAuthController.sceneDelegate = sceneDelegate
  
    }
    
    //MARK: - init
//    private override init() {
//        super.init()
//
//        let config = OIDServiceConfiguration(
//            authorizationEndpoint: URL(string: AppAuthController.authEndpointString)!,
//            tokenEndpoint: URL(string: AppAuthController.tokenEndpointString)!
//        )
//
//        let codeVerifier = OIDAuthorizationRequest.generateCodeVerifier()
//        let codeChallenge = OIDAuthorizationRequest.codeChallengeS256(forVerifier: codeVerifier)
//
//        request = OIDAuthorizationRequest(
//            configuration: config,
//            clientId: AppAuthController.clientID,
//            clientSecret: nil,
//            scope: "eduid.nl/mobile",
//            redirectURL: URL(string: AppAuthController.redirectURIString)!,
//            responseType: OIDResponseTypeCode,
//            state: UUID().uuidString,
//            nonce: UUID().uuidString,
//            codeVerifier: codeVerifier,
//            codeChallenge: codeChallenge,
//            codeChallengeMethod: OIDOAuthorizationRequestCodeChallengeMethodS256,
//            additionalParameters: nil
//        )
//
//    }
    
    public func authorize(viewController: UIViewController, completion: ((String) -> Void)? = nil) {
        let externalUserAgent = OIDExternalUserAgentIOSSafari(presentingViewController: viewController)
//        currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, externalUserAgent: externalUserAgent) { [weak self] authState, error in
//            if let authState = authState {
//                self?.authState = authState
//                self?.accessToken = authState.lastTokenResponse?.accessToken ?? ""
//                self?.refreshToken = authState.lastTokenResponse?.refreshToken ?? ""
//                let token = self?.accessToken
//                completion?(token!)
//            } else {
//                fatalError("authorization failed")
//            }
//        }
        
//        let request = OIDAuthorizationRequest(configuration: configuration,
//                                              clientId: clientID,
//                                              clientSecret: clientSecret,
//                                              scopes: [OIDScopeOpenID, OIDScopeProfile],
//                                              redirectURL: redirectURI,
//                                              responseType: OIDResponseTypeCode,
//                                              additionalParameters: nil)
//
//
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
        
        AppAuthControllersceneDelegate!.currentAuthorizationFlow =
            OIDAuthState.authState(byPresenting: request, presenting: viewController) { authState, error in
          if let authState = authState {
            self.authState = authState
            print("Got authorization tokens. Access token: " +
                  "\(authState.lastTokenResponse?.accessToken ?? "nil")")
          } else {
            print("Authorization error: \(error?.localizedDescription ?? "Unknown error")")
            self.authState = nil
          }
        }

        
        
    }
    
    func refresh(completionHandler: (() -> Void)?) {
        OIDAuthorizationService.perform(tokenRefreshRequest, originalAuthorizationResponse: nil) { [weak self] tokenResponse, error in
            self?.accessToken = tokenResponse?.accessToken ?? ""
            self?.refreshToken = tokenResponse?.refreshToken ?? ""
            completionHandler?()
        }
    }
}


public protocol MySceneDelegateProtocol {
    var currentAuthorizationFlow: OIDExternalUserAgentSession? { get set }
}

