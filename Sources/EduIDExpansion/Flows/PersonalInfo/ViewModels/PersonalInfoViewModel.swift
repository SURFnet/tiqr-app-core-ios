import UIKit
import OpenAPIClient

class PersonalInfoViewModel: NSObject {
    
    var userResponse: UserResponse?
    var dataAvailableCallback: ((PersonalInfoDataCallbackModel) -> Void)?
    
    
    
    override init() {
        super.init()
        
        getData()
    }
    
    func getData() {
        Task {
            do {
                try await userResponse = UserControllerAPI.me()
                
                DispatchQueue.main.async { [weak self] in
                    self?.processUserData()
                }
            }
        }
    }
    
    private func processUserData() {
        guard let userResponse = userResponse else { return }
        
        if userResponse.linkedAccounts?.isEmpty ?? true {
            let name = "\(userResponse.givenName?.first ?? "X"). \(userResponse.familyName ?? "")"
            let nameProvidedBy = "me"
            dataAvailableCallback?(PersonalInfoDataCallbackModel(userResponse: userResponse, name: name, nameProvidedBy: nameProvidedBy, isNameProvidedByInstitution: false))
        } else {
            guard let firstLinkedAccount = userResponse.linkedAccounts?.first else { return }
            
            let name = "\(firstLinkedAccount.givenName?.first ?? "X"). \(firstLinkedAccount.familyName ?? "")"
            let nameProvidedBy = firstLinkedAccount.schacHomeOrganization ?? ""
            let model = PersonalInfoDataCallbackModel(userResponse: userResponse, name: name, nameProvidedBy: nameProvidedBy, isNameProvidedByInstitution: true)
            
            dataAvailableCallback?(model)
        }
    }
}

struct PersonalInfoDataCallbackModel {
    var userResponse: UserResponse
    var name: String
    var nameProvidedBy: String
    var isNameProvidedByInstitution: Bool
}
