import Foundation
import OpenAPIClient

class CreateEduIDFirstTimeDialogViewViewModel: NSObject {
    
    //MARK: - closures
    var addInstitutionsCompletion: ((String) -> Void)?
    
    @MainActor
    func gotoAddInstitutionsInBrowser() {
        Task {
            do {
                let result = try await AccountLinkerControllerAPI.startSPLinkAccountFlow()
                addInstitutionsCompletion?(result)
            } catch {
                print(error)
            }
        }
    }
}
