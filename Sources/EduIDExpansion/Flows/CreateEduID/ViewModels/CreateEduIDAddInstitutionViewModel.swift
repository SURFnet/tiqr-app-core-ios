import Foundation
import OpenAPIClient

class CreateEduIDFirstTimeDialogViewViewModel: NSObject {
    
    //MARK: - closures
    var addInstitutionsCompletion: ((AuthorizationURL) -> Void)?
    private let keychain = KeyChainService()
    
    @MainActor
    func gotoAddInstitutionsInBrowser() {
        Task {
            //TODO: Check ACCESS TOKEN CHECK
            if let accessToken = keychain.getString(for: Constants.KeyChain.accessToken) {
                do {
                    let result = try await AccountLinkerControllerAPI.startSPLinkAccountFlowWithRequestBuilder()
                        .addHeader(name: Constants.Headers.authorization, value: accessToken)
                        .execute()
                        .body
                    
                    addInstitutionsCompletion?(result)
                } catch {
                    print(error)
                }
            }
        }
    }
}
