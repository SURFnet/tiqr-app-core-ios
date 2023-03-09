import UIKit
import OpenAPIClient

class PersonalInfoViewModel: NSObject {
    
    var userResponse: UserResponse?
    
    // - closures
    var dataAvailableClosure: ((PersonalInfoDataCallbackModel) -> Void)?
    var serviceRemovedClosure: ((LinkedAccount) -> Void)?
    var dataFetchErrorClosure: ((Error) -> Void)?
    
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
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.dataFetchErrorClosure?(error)
                }
            }
        }
    }
    
    private func processUserData() {
        guard let userResponse = userResponse else { return }
        
        if userResponse.linkedAccounts?.isEmpty ?? true {
            let name = "\(userResponse.givenName?.first ?? "X"). \(userResponse.familyName ?? "")"
            let nameProvidedBy = "me"
            dataAvailableClosure?(PersonalInfoDataCallbackModel(userResponse: userResponse, name: name, nameProvidedBy: nameProvidedBy, isNameProvidedByInstitution: false))
        } else {
            guard let firstLinkedAccount = userResponse.linkedAccounts?.first else { return }
            
            let name = "\(firstLinkedAccount.givenName?.first ?? "X"). \(firstLinkedAccount.familyName ?? "")"
            let nameProvidedBy = firstLinkedAccount.schacHomeOrganization ?? ""
            let model = PersonalInfoDataCallbackModel(userResponse: userResponse, name: name, nameProvidedBy: nameProvidedBy, isNameProvidedByInstitution: true)
            
            dataAvailableClosure?(model)
        }
    }
    
    func removeLinkedAccount(linkedAccount: LinkedAccount) {
        Task {
            do {
                let result = try await UserControllerAPI.removeUserLinkedAccounts(linkedAccount: linkedAccount)
                if !(result.linkedAccounts?.contains(linkedAccount) ?? true) {
                    DispatchQueue.main.async { [weak self] in
                        self?.serviceRemovedClosure?(linkedAccount)
                    }
                }
            }
        }
    }
}

struct PersonalInfoDataCallbackModel {
    var userResponse: UserResponse
    var name: String
    var nameProvidedBy: String
    var isNameProvidedByInstitution: Bool
}
