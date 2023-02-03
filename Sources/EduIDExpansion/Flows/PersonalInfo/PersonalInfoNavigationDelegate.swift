import Foundation

protocol PersonalInfoNavigationDelegate: AnyObject, NavigationDelegate {
    
    func dismiss()
    func goBack()
}
