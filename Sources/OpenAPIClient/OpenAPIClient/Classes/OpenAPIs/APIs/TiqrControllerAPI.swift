//
// TiqrControllerAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

open class TiqrControllerAPI {

    /**
     De-activate the app
     
     - parameter deactivateRequest: (body)  
     - returns: FinishEnrollment
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func deactivateApp(deactivateRequest: DeactivateRequest) async throws -> FinishEnrollment {
        return try await deactivateAppWithRequestBuilder(deactivateRequest: deactivateRequest).execute().body
    }

    /**
     De-activate the app
     - POST /mobile/tiqr/sp/deactivate-app
     - De-activate the eduID app for the current user
     - parameter deactivateRequest: (body)  
     - returns: RequestBuilder<FinishEnrollment> 
     */
    open class func deactivateAppWithRequestBuilder(deactivateRequest: DeactivateRequest) -> RequestBuilder<FinishEnrollment> {
        let localVariablePath = "/mobile/tiqr/sp/deactivate-app"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: deactivateRequest)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<FinishEnrollment>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Poll enrollment
     
     - parameter enrollmentKey: (query)  
     - returns: String
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func enrollmentStatus(enrollmentKey: String) async throws -> String {
        return try await enrollmentStatusWithRequestBuilder(enrollmentKey: enrollmentKey).execute().body
    }

    /**
     Poll enrollment
     - GET /mobile/tiqr/poll-enrollment
     - Poll Tiqr enrollment status
     - parameter enrollmentKey: (query)  
     - returns: RequestBuilder<String> 
     */
    open class func enrollmentStatusWithRequestBuilder(enrollmentKey: String) -> RequestBuilder<String> {
        let localVariablePath = "/mobile/tiqr/poll-enrollment"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "enrollmentKey": (wrappedValue: enrollmentKey.encodeToJSON(), isExplode: true),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<String>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Finish enrollment
     
     - returns: EnrollmentVerificationKey
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func finishEnrollment() async throws -> EnrollmentVerificationKey {
        return try await finishEnrollmentWithRequestBuilder().execute().body
    }

    /**
     Finish enrollment
     - GET /mobile/tiqr/sp/finish-enrollment
     - Finish Tiqr enrollment for the current user
     - returns: RequestBuilder<EnrollmentVerificationKey> 
     */
    open class func finishEnrollmentWithRequestBuilder() -> RequestBuilder<EnrollmentVerificationKey> {
        let localVariablePath = "/mobile/tiqr/sp/finish-enrollment"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<EnrollmentVerificationKey>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Generate back-up code
     
     - returns: GeneratedBackupCode
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func generateBackupCodeForSp() async throws -> GeneratedBackupCode {
        return try await generateBackupCodeForSpWithRequestBuilder().execute().body
    }

    /**
     Generate back-up code
     - GET /mobile/tiqr/sp/generate-backup-code
     - Generate a back-up code for a finished authentication
     - returns: RequestBuilder<GeneratedBackupCode> 
     */
    open class func generateBackupCodeForSpWithRequestBuilder() -> RequestBuilder<GeneratedBackupCode> {
        let localVariablePath = "/mobile/tiqr/sp/generate-backup-code"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<GeneratedBackupCode>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Generate new back-up code
     
     - returns: GeneratedBackupCode
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func regenerateBackupCodeForSp() async throws -> GeneratedBackupCode {
        return try await regenerateBackupCodeForSpWithRequestBuilder().execute().body
    }

    /**
     Generate new back-up code
     - GET /mobile/tiqr/sp/re-generate-backup-code
     - Generate a new back-up code for a finished authentication
     - returns: RequestBuilder<GeneratedBackupCode> 
     */
    open class func regenerateBackupCodeForSpWithRequestBuilder() -> RequestBuilder<GeneratedBackupCode> {
        let localVariablePath = "/mobile/tiqr/sp/re-generate-backup-code"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<GeneratedBackupCode>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Send new phone code
     
     - parameter phoneCode: (body)  
     - returns: FinishEnrollment
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func resendPhoneCodeForSp(phoneCode: PhoneCode) async throws -> FinishEnrollment {
        return try await resendPhoneCodeForSpWithRequestBuilder(phoneCode: phoneCode).execute().body
    }

    /**
     Send new phone code
     - POST /mobile/tiqr/sp/re-send-phone-code
     - Send a new verification code to mobile phone for a finished authentication
     - parameter phoneCode: (body)  
     - returns: RequestBuilder<FinishEnrollment> 
     */
    open class func resendPhoneCodeForSpWithRequestBuilder(phoneCode: PhoneCode) -> RequestBuilder<FinishEnrollment> {
        let localVariablePath = "/mobile/tiqr/sp/re-send-phone-code"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: phoneCode)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<FinishEnrollment>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Send de-activation code
     
     - returns: FinishEnrollment
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func sendDeactivationPhoneCodeForSp() async throws -> FinishEnrollment {
        return try await sendDeactivationPhoneCodeForSpWithRequestBuilder().execute().body
    }

    /**
     Send de-activation code
     - GET /mobile/tiqr/sp/send-deactivation-phone-code
     - Send a de-activation code to the user
     - returns: RequestBuilder<FinishEnrollment> 
     */
    open class func sendDeactivationPhoneCodeForSpWithRequestBuilder() -> RequestBuilder<FinishEnrollment> {
        let localVariablePath = "/mobile/tiqr/sp/send-deactivation-phone-code"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<FinishEnrollment>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Send phone code
     
     - parameter phoneCode: (body)  
     - returns: FinishEnrollment
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func sendPhoneCodeForSp(phoneCode: PhoneCode) async throws -> FinishEnrollment {
        return try await sendPhoneCodeForSpWithRequestBuilder(phoneCode: phoneCode).execute().body
    }

    /**
     Send phone code
     - POST /mobile/tiqr/sp/send-phone-code
     - Send a verification code to mobile phone for a finished authentication
     - parameter phoneCode: (body)  
     - returns: RequestBuilder<FinishEnrollment> 
     */
    open class func sendPhoneCodeForSpWithRequestBuilder(phoneCode: PhoneCode) -> RequestBuilder<FinishEnrollment> {
        let localVariablePath = "/mobile/tiqr/sp/send-phone-code"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: phoneCode)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<FinishEnrollment>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Poll authentication
     
     - parameter sessionKey: (query) Session key of the authentication 
     - returns: PollAuthenticationResult
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func spAuthenticationStatus(sessionKey: String) async throws -> PollAuthenticationResult {
        return try await spAuthenticationStatusWithRequestBuilder(sessionKey: sessionKey).execute().body
    }

    /**
     Poll authentication
     - GET /mobile/tiqr/sp/poll-authentication
     - Poll Tiqr authentication status for current user
     - parameter sessionKey: (query) Session key of the authentication 
     - returns: RequestBuilder<PollAuthenticationResult> 
     */
    open class func spAuthenticationStatusWithRequestBuilder(sessionKey: String) -> RequestBuilder<PollAuthenticationResult> {
        let localVariablePath = "/mobile/tiqr/sp/poll-authentication"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "sessionKey": (wrappedValue: sessionKey.encodeToJSON(), isExplode: true),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<PollAuthenticationResult>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Manual authentication
     
     - parameter manualResponse: (body)  
     - returns: FinishEnrollment
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func spManualResponse(manualResponse: ManualResponse) async throws -> FinishEnrollment {
        return try await spManualResponseWithRequestBuilder(manualResponse: manualResponse).execute().body
    }

    /**
     Manual authentication
     - POST /mobile/tiqr/sp/manual-response
     - Manual Tiqr authentication response
     - parameter manualResponse: (body)  
     - returns: RequestBuilder<FinishEnrollment> 
     */
    open class func spManualResponseWithRequestBuilder(manualResponse: ManualResponse) -> RequestBuilder<FinishEnrollment> {
        let localVariablePath = "/mobile/tiqr/sp/manual-response"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: manualResponse)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<FinishEnrollment>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Verify phone code again
     
     - parameter phoneVerification: (body)  
     - returns: VerifyPhoneCode
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func spReverifyPhoneCode(phoneVerification: PhoneVerification) async throws -> VerifyPhoneCode {
        return try await spReverifyPhoneCodeWithRequestBuilder(phoneVerification: phoneVerification).execute().body
    }

    /**
     Verify phone code again
     - POST /mobile/tiqr/sp/re-verify-phone-code
     - Verify verification code again for a finished authentication
     - parameter phoneVerification: (body)  
     - returns: RequestBuilder<VerifyPhoneCode> 
     */
    open class func spReverifyPhoneCodeWithRequestBuilder(phoneVerification: PhoneVerification) -> RequestBuilder<VerifyPhoneCode> {
        let localVariablePath = "/mobile/tiqr/sp/re-verify-phone-code"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: phoneVerification)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<VerifyPhoneCode>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Verify phone code
     
     - parameter phoneVerification: (body)  
     - returns: VerifyPhoneCode
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func spVerifyPhoneCode(phoneVerification: PhoneVerification) async throws -> VerifyPhoneCode {
        return try await spVerifyPhoneCodeWithRequestBuilder(phoneVerification: phoneVerification).execute().body
    }

    /**
     Verify phone code
     - POST /mobile/tiqr/sp/verify-phone-code
     - Verify verification code for a finished authentication
     - parameter phoneVerification: (body)  
     - returns: RequestBuilder<VerifyPhoneCode> 
     */
    open class func spVerifyPhoneCodeWithRequestBuilder(phoneVerification: PhoneVerification) -> RequestBuilder<VerifyPhoneCode> {
        print("VERIFYING PHONE CODE: \(OpenAPIClientAPI.customHeaders)" )
        let localVariablePath = "/mobile/tiqr/sp/verify-phone-code"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: phoneVerification)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<VerifyPhoneCode>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Start authentication
     
     - returns: StartAuthentication
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func startAuthenticationForSP() async throws -> StartAuthentication {
        return try await startAuthenticationForSPWithRequestBuilder().execute().body
    }

    /**
     Start authentication
     - POST /mobile/tiqr/sp/start-authentication
     - Start Tiqr authentication for current user
     - returns: RequestBuilder<StartAuthentication> 
     */
    open class func startAuthenticationForSPWithRequestBuilder() -> RequestBuilder<StartAuthentication> {
        let localVariablePath = "/mobile/tiqr/sp/start-authentication"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<StartAuthentication>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Start enrollment
     
     - returns: StartEnrollment
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func startEnrollment() async throws -> StartEnrollment {
        return try await startEnrollmentWithRequestBuilder().execute().body
    }

    /**
     Start enrollment
     - GET /mobile/tiqr/sp/start-enrollment
     - Start Tiqr enrollment for the current user
     - returns: RequestBuilder<StartEnrollment> 
     */
    open class func startEnrollmentWithRequestBuilder() -> RequestBuilder<StartEnrollment> {
        let localVariablePath = "/mobile/tiqr/sp/start-enrollment"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<StartEnrollment>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }
}
