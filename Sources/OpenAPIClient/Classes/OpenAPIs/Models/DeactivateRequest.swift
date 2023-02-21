//
// DeactivateRequest.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct DeactivateRequest: Codable, JSONEncodable, Hashable {

    public var verificationCode: String?

    public init(verificationCode: String? = nil) {
        self.verificationCode = verificationCode
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case verificationCode
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(verificationCode, forKey: .verificationCode)
    }
}

