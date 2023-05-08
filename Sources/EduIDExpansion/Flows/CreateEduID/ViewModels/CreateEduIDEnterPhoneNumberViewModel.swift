import Foundation
import OpenAPIClient

class CreateEduIDEnterPhoneNumberViewModel: NSObject {
    
    //MARK: - closures
    var phoneNumberReceivedClosure: ((FinishEnrollment) -> Void)?
    private let keychain = KeyChainService()
    
    //MARK: - init
    override init() {
        super.init()
    }
    
    @MainActor
    func sendPhoneNumber(number: String) {
        Task {
            do {
                let result = try await TiqrControllerAPI.sendPhoneCodeForSpWithRequestBuilder(phoneCode: PhoneCode(phoneNumber: number))
                    .addHeader(name: Constants.Headers.authorization, value: keychain.getString(for: Constants.KeyChain.accessToken) ?? "")
                    .execute()
                    .body
                phoneNumberReceivedClosure?(result)
            } catch let error {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
}
