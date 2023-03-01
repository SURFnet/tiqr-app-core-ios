//
//  File.swift
//  
//
//  Created by Jairo Bambang Oetomo on 01/03/2023.
//

import Foundation

struct LocalizedKey {
    struct  sidebar {
        var home = "home"
        var personalInfo = "personalInfo"
        var dataActivity = "dataActivity"
        var security = "security"
        var account = "account"
    }
    struct  start {
        var hi = "hi"
        var manage = "manage"
    }
    struct  header {
        var title = "title"
        var logout = "logout"
    }
    struct  landing {
        var logoutTitle = "logoutTitle"
        var logoutStatus = "logoutStatus"
        var loginAgain = "loginAgain"
        var deleteTitle = "deleteTitle"
        var deleteStatus = "deleteStatus"
        var registerAgain = "registerAgain"
    }
    struct  notFound {
        var title = "title"
        var title2 = "title2"
    }
    struct  profile {
        var title = "title"
        var info = "info"
        var basic = "basic"
        var email = "email"
        var name = "name"
        var validated = "validated"
        var firstAndLastName = "firstAndLastName"
        var firstAndLastNameInfo = "firstAndLastNameInfo"
        var verify = "verify"
        var student = "student"
        var studentInfo = "studentInfo"
        var prove = "prove"
        var trusted = "trusted"
        var trustedInfo = "trustedInfo"
        var link = "link"
        var institution = "institution"
        var affiliations = "affiliations"
        var expires = "expires"
        var expiresValue = "expiresValue"
        var verifiedAt = "verifiedAt"
        var proceed = "proceed"
    }
    struct  verifyFirstAndLastName {
        var addInstitution = "addInstitution"
        var addInstitutionConfirmation = "addInstitutionConfirmation"
    }
    struct  verifyStudent {
        var addInstitution = "addInstitution"
        var addInstitutionConfirmation = "addInstitutionConfirmation"
    }
    struct  verifyParty {
        var addInstitution = "addInstitution"
        var addInstitutionConfirmation = "addInstitutionConfirmation"
    }
    struct  eppnAlreadyLinked {
        var header = "header"
        var info = "info"
        var infoNew = "infoNew"
        var retryLink = "retryLink"
    }
    struct  edit {
        var title = "title"
        var info = "info"
        var givenName = "givenName"
        var familyName = "familyName"
        var update = "update"
        var cancel = "cancel"
        var updated = "updated"
        var back = "back"
    }
    struct  email {
        var title = "title"
        var info = "info"
        var email = "email"
        var update = "update"
        var cancel = "cancel"
        var updated = "updated"
        var confirmed = "confirmed"
        var back = "back"
        var emailEquality = "emailEquality"
        var duplicateEmail = "duplicateEmail"
        var outstandingPasswordForgotten = "outstandingPasswordForgotten"
        var outstandingPasswordForgottenConfirmation = "outstandingPasswordForgottenConfirmation"
    }
    struct  security {
        var title = "title"
        var subTitle = "subTitle"
        var secondSubTitle = "secondSubTitle"
        var usePassword = "usePassword"
        var usePublicKey = "usePublicKey"
        var notSet = "notSet"
        var notSupported = "notSupported"
        var useMagicLink = "useMagicLink"
        var rememberMe = "rememberMe"
        var securityKey = "securityKey"
        var test = "test"
        var addSecurityKey = "addSecurityKey"
        var addSecurityKeyInfo = "addSecurityKeyInfo"
        var settings = "settings"
        var rememberMeInfo = "rememberMeInfo"
        var noRememberMeInfo = "noRememberMeInfo"
        var forgetMe = "forgetMe"
    }
    struct  tiqr {
        var title = "title"
        var info = "info"
        var fetch = "fetch"
        var deactivate = "deactivate"
        var backupCodes = "backupCodes"
        var app = "app"
        var phoneId = "phoneId"
        var APNS = "APNS"
        var APNS_DIRECT = "APNS_DIRECT"
        var FCM = "FCM"
        var GCM = "GCM"
        var FCM_DIRECT = "FCM_DIRECT"
        var appCode = "appCode"
        var lastLogin = "lastLogin"
        var activated = "activated"
        var dateTimeOn = "dateTimeOn"
        var backupMethod = "backupMethod"
        var sms = "sms"
        var code = "code"
    }
    struct  home {
        var home = "home"
        var welcome = "welcome"
        var dataActivity = "data-activity"
        var personal = "personal"
        var security = "security"
        var account = "account"
        var institutions = "institutions"
        var services = "services"
        var favorites = "favorites"
        var settings = "settings"
    }
    struct  links {
        var teams = "teams"
        var teamsHref = "teamsHref"
    }
    struct  account {
        var title = "title"
        var titleDelete = "titleDelete"
        var info = "info"
        var created = "created"
        var delete = "delete"
        var cancel = "cancel"
        var deleteInfo = "deleteInfo"
        var data = "data"
        var personalInfo = "personalInfo"
        var downloadData = "downloadData"
        var downloadDataConfirmation = "downloadDataConfirmation"
        var deleteTitle = "deleteTitle"
        var info1 = "info1"
        var info2 = "info2"
        var info3 = "info3"
        var info4 = "info4"
        var deleteAccount = "deleteAccount"
        var deleteAccountConfirmation = "deleteAccountConfirmation"
        var deleteAccountSure = "deleteAccountSure"
        var deleteAccountWarning = "deleteAccountWarning"
        var proceed = "proceed"
        var name = "name"
        var namePlaceholder = "namePlaceholder"
    }
    struct  dataActivity {
        var title = "title"
        var info = "info"
        var explanation = "explanation"
        var noServices = "noServices"
        var name = "name"
        var add = "add"
        var access = "access"
    }
    struct  details {
        var login = "login"
        var delete = "delete"
        var first = "first"
        var eduID = "eduID"
        var homePage = "homePage"
        var deleteDisclaimer = "deleteDisclaimer"
        var access = "access"
        var details = "details"
        var consent = "consent"
        var expires = "expires"
        var revoke = "revoke"
        var deleteService = "deleteService"
        var deleteServiceConfirmation = "deleteServiceConfirmation"
        var deleteTokenConfirmation = "deleteTokenConfirmation"
        var deleteToken = "deleteToken"
        var deleted = "deleted"
        var tokenDeleted = "tokenDeleted"
    }
    struct  institution {
        var title = "title"
        var info = "info"
        var name = "name"
        var eppn = "eppn"
        var displayName = "displayName"
        var affiliations = "affiliations"
        var expires = "expires"
        var expiresValue = "expiresValue"
        var delete = "delete"
        var cancel = "cancel"
        var deleted = "deleted"
        var back = "back"
        var deleteInstitution = "deleteInstitution"
        var deleteInstitutionConfirmation = "deleteInstitutionConfirmation"
    }
    struct  credential {
        var title = "title"
        var info = "info"
        var name = "name"
        var cancel = "cancel"
        var update = "update"
        var deleted = "deleted"
        var updated = "updated"
        var back = "back"
        var deleteCredential = "deleteCredential"
        var deleteCredentialConfirmation = "deleteCredentialConfirmation"
    }
    struct  password {
        var addTitle = "addTitle"
        var updateTitle = "updateTitle"
        var addInfo = "addInfo"
        var updateInfo = "updateInfo"
        var resetTitle = "resetTitle"
        var newPassword = "newPassword"
        var confirmPassword = "confirmPassword"
        var setUpdate = "setUpdate"
        var updateUpdate = "updateUpdate"
        var cancel = "cancel"
        var set = "set"
        var reset = "reset"
        var updated = "updated"
        var deleted = "deleted"
        var deletePassword = "deletePassword"
        var deletePasswordConfirmation = "deletePasswordConfirmation"
        var back = "back"
        var passwordDisclaimer = "passwordDisclaimer"
        var invalidCurrentPassword = "invalidCurrentPassword"
        var passwordResetHashExpired = "passwordResetHashExpired"
        var forgotPassword = "forgotPassword"
        var passwordResetSendAgain = "passwordResetSendAgain"
        var forgotPasswordConfirmation = "forgotPasswordConfirmation"
        var outstandingEmailReset = "outstandingEmailReset"
        var outstandingEmailResetConfirmation = "outstandingEmailResetConfirmation"
    }
    struct  flash {
        var passwordLink = "passwordLink"
    }
    struct  webauthn {
        var setTitle = "setTitle"
        var updateTitle = "updateTitle"
        var publicKeys = "publicKeys"
        var noPublicKeys = "noPublicKeys"
        var nameRequired = "nameRequired"
        var revoke = "revoke"
        var addDevice = "addDevice"
        var info = "info"
        var back = "back"
        var setUpdate = "setUpdate"
        var updateUpdate = "updateUpdate"
        var credentialName = "credentialName"
        var credentialNamePlaceholder = "credentialNamePlaceholder"
        var test = "test"
        var testInfo = "testInfo"
        var testFlash = "testFlash"
    }
    struct  rememberMe {
        var updated = "updated"
        var forgetMeTitle = "forgetMeTitle"
        var info = "info"
        var cancel = "cancel"
        var update = "update"
        var forgetMeConfirmation = "forgetMeConfirmation"
        var forgetMe = "forgetMe"
    }
    struct  footer {
        var privacy = "privacy"
        var terms = "terms"
        var help = "help"
        var poweredBy = "poweredBy"
    }
    struct  modal {
        var cancel = "cancel"
        var confirm = "confirm"
    }
    struct  format {
        var creationDate = "creationDate"
    }
    struct  getApp {
        var header = "header"
        var info = "info"
        var google = "google"
        var apple = "apple"
        var after = "after"
        var back = "back"
        var next = "next"
    }
    struct  sms {
        var header = "header"
        var info = "info"
        var codeIncorrect = "codeIncorrect"
        var maxAttemptsPre = "maxAttemptsPre"
        var maxAttemptsPost = "maxAttemptsPost"
        var maxAttemptsPostNoReEnter = "maxAttemptsPostNoReEnter"
        var here = "here"
    }
    struct  enrollApp {
        var header = "header"
        var scan = "scan"
        var timeOut = "timeOut"
        var timeOutInfoFirst = "timeOutInfoFirst"
        var timeOutInfoLast = "timeOutInfoLast"
        var timeOutInfoLink = "timeOutInfoLink"
        var openEduIDApp = "openEduIDApp"
    }
    struct  recovery {
        var header = "header"
        var changeHeader = "changeHeader"
        var info = "info"
        var changeInfo = "changeInfo"
        var methods = "methods"
        var phoneNumber = "phoneNumber"
        var phoneNumberInfo = "phoneNumberInfo"
        var backupCode = "backupCode"
        var backupCodeInfo = "backupCodeInfo"
        var save = "save"
        var active = "active"
        var copy = "copy"
        var copied = "copied"
        var cnt = "continue"
        var leaveConfirmation = "leaveConfirmation"
    }
    struct  phoneVerification {
        var header = "header"
        var info = "info"
        var text = "text"
        var verify = "verify"
        var placeHolder = "placeHolder"
        var phoneIncorrect = "phoneIncorrect"
    }
    struct  congrats {
        var header = "header"
        var info = "info"
        var changeInfo = "changeInfo"
        var next = "next"
    }
    struct  deactivate {
        var titleDelete = "titleDelete"
        var info = "info"
        var recoveryCode = "recoveryCode"
        var recoveryCodeInfo = "recoveryCodeInfo"
        var verificationCode = "verificationCode"
        var codeIncorrect = "codeIncorrect"
        var next = "next"
        var deactivateApp = "deactivateApp"
        var sendSms = "sendSms"
        var maxAttempts = "maxAttempts"
    }
    struct  backupCodes {
        var title = "title"
        var info = "info"
        var phoneNumber = "phoneNumber"
        var startTiqrAuthentication = "startTiqrAuthentication"
        var code = "code"
    }
    struct  useApp {
        var header = "header"
        var info = "info"
        var scan = "scan"
        var noNotification = "noNotification"
        var qrCodeLink = "qrCodeLink"
        var qrCodePostfix = "qrCodePostfix"
        var offline = "offline"
        var offlineLink = "offlineLink"
        var lost = "lost"
        var lostLink = "lostLink"
        var timeOut = "timeOut"
        var timeOutInfoFirst = "timeOutInfoFirst"
        var timeOutInfoLast = "timeOutInfoLast"
        var timeOutInfoLink = "timeOutInfoLink"
        var responseIncorrect = "responseIncorrect"
        var suspendedResult = "suspendedResult"
        var accountNotSuspended = "accountNotSuspended"
        var accountSuspended = "accountSuspended"
        var minutes = "minutes"
        var minute = "minute"
    }
    struct  createFromInstitution {
        var title = "title"
        var header = "header"
        var alreadyHaveAnEduID = "alreadyHaveAnEduID"
        var info = "info"
        var startFlow = "startFlow"
        var welcome = "welcome"
        var welcomeExisting = "welcomeExisting"
    }
    struct  linkFromInstitution {
        var header = "header"
        var info = "info"
        var email = "email"
        var emailPlaceholder = "emailPlaceholder"
        var emailForbidden = "emailForbidden"
        var emailInUse1 = "emailInUse1"
        var emailInUse2 = "emailInUse2"
        var emailInUse3 = "emailInUse3"
        var invalidEmail = "invalidEmail"
        var institutionDomainNameWarning = "institutionDomainNameWarning"
        var institutionDomainNameWarning2 = "institutionDomainNameWarning2"
        var allowedDomainNamesError = "allowedDomainNamesError"
        var allowedDomainNamesError2 = "allowedDomainNamesError2"
        var agreeWithTerms = "agreeWithTerms"
        var requestEduIdButton = "requestEduIdButton"
    }
    struct  pollFromInstitution {
        var header = "header"
        var info = "info"
        var awaiting = "awaiting"
        var openGMail = "openGMail"
        var openOutlook = "openOutlook"
        var spam = "spam"
        var loggedIn = "loggedIn"
        var loggedInInfo = "loggedInInfo"
        var timeOutReached = "timeOutReached"
        var timeOutReachedInfo = "timeOutReachedInfo"
        var resend = "resend"
        var resendLink = "resendLink"
        var mailResend = "mailResend"
    }        
}
