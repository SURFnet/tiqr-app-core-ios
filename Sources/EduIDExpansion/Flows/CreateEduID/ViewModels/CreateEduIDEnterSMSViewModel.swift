import Foundation
import OpenAPIClient

class CreateEduIDEnterSMSViewModel: NSObject {
    
    //MARK: - closures
    var smsEntryWasCorrect: ((VerifyPhoneCode) -> Void)?
    
    func enterSMS(code: String) {
        Task {
            do {
                let result = try await TiqrControllerAPI.spVerifyPhoneCode(phoneVerification: PhoneVerification(phoneVerification: code))
                smsEntryWasCorrect?(result)
            } catch {
                print(error)
            }
        }
    }
}
