import Foundation
import OpenAPIClient

class CreateEduIDEnterSMSViewModel: NSObject {
    
    //MARK: - closures
    var smsEntryWasCorrect: ((VerifyPhoneCode) -> Void)?
    private let keychain = KeyChainService()
    
    func enterSMS(code: String) {
        Task {
            //TODO: Check ACCESS TOKEN CHECK
            if let accessToken = keychain.getString(for: Constants.KeyChain.accessToken) {
                do {
                    let result = try await TiqrControllerAPI.spVerifyPhoneCodeWithRequestBuilder(phoneVerification: PhoneVerification(phoneVerification: code))
                        .addHeader(name: Constants.Headers.authorization, value: accessToken)
                        .execute()
                        .body
                    smsEntryWasCorrect?(result)
                } catch {
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }
}
