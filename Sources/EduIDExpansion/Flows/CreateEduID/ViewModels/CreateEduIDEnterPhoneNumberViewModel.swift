import Foundation
import OpenAPIClient

class CreateEduIDEnterPhoneNumberViewModel: NSObject {
    
    //MARK: - closures
    var phoneNumberReceivedClosure: ((FinishEnrollment) -> Void)?
    
    //MARK: - init
    override init() {
        super.init()
    }
    
    @MainActor
    func sendPhoneNumber(number: String) {
        Task {
            do {
                let result = try await TiqrControllerAPI.sendPhoneCodeForSp(phoneCode: PhoneCode(phoneNumber: number))
                phoneNumberReceivedClosure?(result)
            } catch let error as NSError {
                assertionFailure("\(error.localizedDescription)")
            }
        }
    }
    
}
