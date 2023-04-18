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
        OpenAPIClientAPI.customHeaders = ["Authorization": "Bearer " + AppAuthController.shared.accessToken]
        Task {
            do {
                let result = try await TiqrControllerAPI.sendPhoneCodeForSp(phoneCode: PhoneCode(phoneNumber: number))
                phoneNumberReceivedClosure?(result)
            } catch let error {
                print("ERROR WHILE SAVING PHONE: \(error.localizedDescription)")
            }
        }
    }
    
}
