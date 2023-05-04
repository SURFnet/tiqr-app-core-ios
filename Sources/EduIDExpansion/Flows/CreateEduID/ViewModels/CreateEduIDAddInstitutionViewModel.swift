import Foundation
import OpenAPIClient

class CreateEduIDFirstTimeDialogViewViewModel: NSObject {
    
    //MARK: - closures
    var addInstitutionsCompletion: ((AuthorizationURL) -> Void)?
    private let keychain = KeyChainService()
    
    @MainActor
    func gotoAddInstitutionsInBrowser() {
        Task {
            do {
                let result = try await AccountLinkerControllerAPI.startSPLinkAccountFlowWithRequestBuilder()
                    .addHeader(name: Constants.Headers.authorization, value: keychain.getString(for: Constants.KeyChain.accessToken))
                    .execute()
                    .body
                
                addInstitutionsCompletion?(result)
            } catch {
                print(error)
            }
        }
    }
}
