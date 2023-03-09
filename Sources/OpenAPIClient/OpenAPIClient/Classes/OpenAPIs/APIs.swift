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
    public static var customHeaders: [String: String] = ["Authorization":"Bearer eyJraWQiOiJrZXlfMjAyM18wM18wOV8wMF8wMF8wMF8wMTQiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOlsiZGV2LmVnZW5pcS5ubCIsIm15Y29uZXh0LnJzIl0sInN1YiI6ImRldi5lZ2VuaXEubmwiLCJuYmYiOjE2NzgzNjI1MDYsInNjb3BlIjoiZWR1aWQubmxcL21vYmlsZSIsImlzcyI6Imh0dHBzOlwvXC9jb25uZWN0LnRlc3QyLnN1cmZjb25leHQubmwiLCJjbGFpbXMiOiJBVW1xU0tlYVhNcW53Z2NxYzAwSHVmNjdNMldtbTBjb1wvZk9xeGtrRHJkVjI0YzFmbXRSRUdEVmhVT3BROXZ0TnFxQUpqanE2NUZcL1VNOE1yMnU0VlBZZVRzVmxKdXFGeGd0N3J6Q3NVdWYxaFhZTVYxRUpUeDBWK3ZVKzBIWXlOR2padEx5a0xKMUVycUhNa0dXdG85QlZyVFlVdUxrbzk0cGZYd0FjbytwbllrZzhPTlZORXg5UlRoa2JJR29FU2EwQitKT052elMweWxYTmtaTWtJRGxaSFVxN2lpNmtcL2o5K3JSWDJXb3BPcDd0MzVWSHhuMVlQdWw3NGN1WnI5Z3J2aGljaDdKcnI4ZnBGNHhUbWpOTE95MlR6cnF3MmV1elJNM0tnWEhTblhQTmtFQXUxNXdBbDZpYmJNUWpBV0N6U3k0WGg4YllzY3dkSzI0dXZkcjk3UnV1YmluT2R5cHNmYW0wUmRPdHo1TTl2VE5ma2o3VVwvYkZsR1Rvdk9KcmRvbW5wdmp1dlhXY3dzdlVtQVpzcVBpUmNSQ01BVjBOU2l5cFlUXC9xS1NTUXFLOHVFczR4MzdrdUNcL1RXcFNIeW9halV2ckxlaVozRSs0bEVSeWhDWGxRQ0FzT3R6NzYxTlF2NlM2RlFLZG1DZGxpTE53VWs2SXZIMFdoeTZyR0FuckZwNjRWeVBvXC9NdXlQTVRKK3NSWXNpbzRndm5CTUhGZ1dmXC8xXC8rb2MyQ2F2dnM5dXd1eGxWWkltXC93UHVjUzFNMUNoeHVUU2llVHc1dHJvaEpQWHRmTVZjZ28raXNmRE1SM3NEejdaN2RlN0pZYW50UVlGcnRLUUNaemQwRHdPdzVmWVZyRmVCalB6WldYXC93aXY3VXRDZmVsdjJhT1FUcHkiLCJleHAiOjE2NzgzNjYxMDYsImNsYWltX2tleV9pZCI6IjEyMzU4OTY0ODciLCJpYXQiOjE2NzgzNjI1MDYsImp0aSI6ImU1ZDZhYWU1LWU0Y2YtNDRlNy05MjAxLWQxZGVlMDU5MGNmYSJ9.B8AX_s9AOba50ZbLN3noWTOdlq_ccl-QkCjH3AIJ6WJfoiM5DVv0-zH2oVyYUbQ3CZGiPkiJmEqUCljtHy5OnnsA6_CJa4aA0VKOL7bd-VLV9BJJMtqkzydAJt0QnSkKvkTNenCSMhsaRijXg_hCGulSTlWgOT6jkn3IKP47HPaf4sF2MM2Wb6kpbGr5COcsn4EvRrOlBAeSCb1pvcWamR0WDaFm1i7CZ-vVZF9ksjJWYt4bd35fdzQFX7C3WPs8TXphBE-CCAcS8_CF4POJmzmSSvr2twnrnOZeRRg7yT8Vb_qz5QtAkqyIomXGZIVki71SoZcqCl708W68o46JVw"]
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
