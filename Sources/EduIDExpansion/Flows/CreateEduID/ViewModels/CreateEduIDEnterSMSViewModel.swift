import Foundation
import OpenAPIClient
import UIKit

class CreateEduIDEnterSMSViewModel: NSObject {
    
    //MARK: - closures
    var smsEntryWasCorrect: ((VerifyPhoneCode) -> Void)?
    private let keychain = KeyChainService()
    
    func enterSMS(code: String) {
        Task {
            do {
                let result = try await TiqrControllerAPI.spVerifyPhoneCodeWithRequestBuilder(phoneVerification: PhoneVerification(phoneVerification: code))
                    .addHeader(name: Constants.Headers.authorization, value: keychain.getString(for: Constants.KeyChain.accessToken))
                    .execute()
                    .body
                smsEntryWasCorrect?(result)
            } catch {
                print(error)
            }
        }
    }
}
