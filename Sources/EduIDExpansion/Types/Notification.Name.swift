import Foundation

extension Notification.Name {
    
    public static let createEduIDDidReturnFromMagicLink = Notification.Name("createEduIDDidReturnFromMagicLink")
    public static let didAddLinkedAccounts = Notification.Name("didAddLinkedAccounts")
    public static let firstTimeAuthorizationComplete = Notification.Name(rawValue: "firstTimeAuthorizationComplete")
    public static let firstTimeAuthorizationCompleteWithSecretPresent = Notification.Name(rawValue: "firstTimeAuthorizationCompleteWithSecretPresent")
    
}
