import Foundation
import OpenAPIClient

class CreateEduIDEnterSMSViewModel: NSObject {
    
    //MARK: - closures
    var smsEntryWasCorrect: ((VerifyPhoneCode) -> Void)?
    private let keychain = KeyChainService()
    
    func enterSMS(code: String) {
        Task {
            do {
                let result = try await TiqrControllerAPI.spVerifyPhoneCodeWithRequestBuilder(phoneVerification: PhoneVerification(phoneVerification: code))
                    .execute()
                    .body
                smsEntryWasCorrect?(result)
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
