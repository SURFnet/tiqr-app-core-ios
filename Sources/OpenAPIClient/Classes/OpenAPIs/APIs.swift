// APIs.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

// We reverted the change of OpenAPIClientAPI to OpenAPIClient introduced in https://github.com/OpenAPITools/openapi-generator/pull/9624
// Because it was causing the following issue https://github.com/OpenAPITools/openapi-generator/issues/9953
// If you are affected by this issue, please consider removing the following two lines,
// By setting the option removeMigrationProjectNameClass to true in the generator
@available(*, deprecated, renamed: "OpenAPIClientAPI")
public typealias OpenAPIClient = OpenAPIClientAPI

open class OpenAPIClientAPI {
    public static var basePath = "https://login.test2.eduid.nl"
    public static var customHeaders: [String: String] = ["Authorization":"Bearer eyJraWQiOiJrZXlfMjAyM18wM18wMV8wMF8wMF8wMF8wMDEiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOlsiZGV2LmVnZW5pcS5ubCIsIm15Y29uZXh0LnJzIl0sInN1YiI6ImRldi5lZ2VuaXEubmwiLCJuYmYiOjE2Nzc2NTU5NzksInNjb3BlIjoiZWR1aWQubmxcL21vYmlsZSIsImlzcyI6Imh0dHBzOlwvXC9jb25uZWN0LnRlc3QyLnN1cmZjb25leHQubmwiLCJjbGFpbXMiOiJBUTkxeUt4eVNNRzB0eWFXQUhPakJqNXA3VUNJMWI5aEFCWXI5SjljRDlycmZaaW9uK0hJMUVrWFwvV2hCSDVOeDAxRmE1dzJDa1pRTVBaWVdITTNqaEZ5cXQyb3M2WDFmRHNYME85eFNySUpLeXRWQnU3bUc1MXlvSmNueXIwdzZLTzVFVDlkZ2xWTnFFUU13MjlsbEtiSDBqR01McnFJT2JzZU1wSkg2OW5LbHJrTzQzT1Q5eG14MVg2SGl0Ykk1bnVSdnZKb3QyYkw1OTZxOFpHVklVQ3Z3blBKdUNPOFlLeFJPS29abCtUTkVFQTd4UldwY3VRT2tLMnFRTEViWjd0alVNWGVVUGs1OCtKMThQMjFYWmdBUE0xYWNFYmxBTjZoTUwydktWSVdBNmJjWWpHK1FUc0lcLzh0Mk9nV3lXTjlGNkx2bTk0am5wcXVGcEFpWlwvV2N5WGlpb0tJTWNzbVwvdXppWFMxY0tYeUdhanhcL0YwOUJQdndkczBIcHU1bXlVK3hZK3lPVXFoUmtvUURRdzZ4d0lPbG15XC93UWVMVVQ5TUd2VEJrVTB6dWJoWktidlwvMlhaa2FcL0ZmWHZkanZXYWRPNnlwUWRZMFZrRG55M3F5YkRqMjd0NHBZaHR3ck5zZFBBYjVSR1U3OWRSXC9icEtFRHFLRm5VMWFhRzhyYTNwQVg1QytQVnNIQzBLb0J4WVJyWGkrenl5allNRVwvRmFqY2xrMmZJRXBMTWtCb2dTa2Y5dTRQcVNMc3hQQ01MSU80M0R1ZEdqQnRlZ2lMbnpFakcwRW5ObWZ0XC9xVld3TTFUTVV6Z3dEaFhzRzlVYks0dFNzRHBXRmJtd2tPNjBTd0dmUlYrZUVoOTc1cFwvRlByTUFGb3p1aFZTVkxxMHJuWVp3IiwiZXhwIjoxNjc3NjU5NTc5LCJjbGFpbV9rZXlfaWQiOiIyNTkzNzczMjQiLCJpYXQiOjE2Nzc2NTU5NzksImp0aSI6ImIzNzU4OTk0LTYxMTYtNGE2MS04NTg2LWFmZTBlNGQ0OTA5MCJ9.ESjbqVKUGjs8h7NUlzhqyc_4Mi1Q_Hsj_K6dgsFZ_NCkwHLYZRJufomeEI5l12t0SZds8BMCdcUUJ091czE6vWzxIiNboylpzz9lg8UaZsq949DRevfjKAXHq162SvcySPyVq5-ARPaE3wqu75QUWt0zRXl9pihiUazSFpcoQoLsYD46YRSsmsKbhlUi8-UK9lTfcgTT1KOc9i1M_9diKf87rNSakzuFGK_sEbegNUDjGv-qCv1ieWVzO-abyzTBgwx7HsRajJNAbT6jiC1Q36oYYiOXQkvehN-n-_VPuSBI_hIXc8W7ujOMfBMAUa4EW5zskksl5UPixS5J3OGM_A"]
    public static var credential: URLCredential?
    public static var requestBuilderFactory: RequestBuilderFactory = URLSessionRequestBuilderFactory()
    public static var apiResponseQueue: DispatchQueue = .main
}

open class RequestBuilder<T> {
    var credential: URLCredential?
    var headers: [String: String]
    public let parameters: [String: Any]?
    public let method: String
    public let URLString: String
    public let requestTask: RequestTask = RequestTask()
    public let requiresAuthentication: Bool

    /// Optional block to obtain a reference to the request's progress instance when available.
    /// With the URLSession http client the request's progress only works on iOS 11.0, macOS 10.13, macCatalyst 13.0, tvOS 11.0, watchOS 4.0.
    /// If you need to get the request's progress in older OS versions, please use Alamofire http client.
    public var onProgressReady: ((Progress) -> Void)?

    required public init(method: String, URLString: String, parameters: [String: Any]?, headers: [String: String] = [:], requiresAuthentication: Bool) {
        self.method = method
        self.URLString = URLString
        self.parameters = parameters
        self.headers = headers
        self.requiresAuthentication = requiresAuthentication

        addHeaders(OpenAPIClientAPI.customHeaders)
    }

    open func addHeaders(_ aHeaders: [String: String]) {
        for (header, value) in aHeaders {
            headers[header] = value
        }
    }

    @discardableResult
    open func execute(_ apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, _ completion: @escaping (_ result: Swift.Result<Response<T>, ErrorResponse>) -> Void) -> RequestTask {
        return requestTask
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    @discardableResult
    open func execute() async throws -> Response<T> {
        return try await withTaskCancellationHandler {
            try Task.checkCancellation()
            return try await withCheckedThrowingContinuation { continuation in
                guard !Task.isCancelled else {
                  continuation.resume(throwing: CancellationError())
                  return
                }

                self.execute { result in
                    switch result {
                    case let .success(response):
                        continuation.resume(returning: response)
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        } onCancel: {
            self.requestTask.cancel()
        }
    }
    
    public func addHeader(name: String, value: String) -> Self {
        if !value.isEmpty {
            headers[name] = value
        }
        return self
    }

    open func addCredential() -> Self {
        credential = OpenAPIClientAPI.credential
        return self
    }
}

public protocol RequestBuilderFactory {
    func getNonDecodableBuilder<T>() -> RequestBuilder<T>.Type
    func getBuilder<T: Decodable>() -> RequestBuilder<T>.Type
}
