//
// Token.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct Token: Codable, JSONEncodable, Hashable {

    public enum ModelType: String, Codable, CaseIterable {
        case access = "ACCESS"
        case refresh = "REFRESH"
    }
    public var id: String?
    public var expiresIn: String?
    public var createdAt: String?
    public var clientName: String?
    public var clientId: String?
    public var type: ModelType?
    public var audiences: [String]?
    public var scopes: [Scope]?

    public init(id: String? = nil, expiresIn: String? = nil, createdAt: String? = nil, clientName: String? = nil, clientId: String? = nil, type: ModelType? = nil, audiences: [String]? = nil, scopes: [Scope]? = nil) {
        self.id = id
        self.expiresIn = expiresIn
        self.createdAt = createdAt
        self.clientName = clientName
        self.clientId = clientId
        self.type = type
        self.audiences = audiences
        self.scopes = scopes
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case expiresIn
        case createdAt
        case clientName
        case clientId
        case type
        case audiences
        case scopes
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(expiresIn, forKey: .expiresIn)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(clientName, forKey: .clientName)
        try container.encodeIfPresent(clientId, forKey: .clientId)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(audiences, forKey: .audiences)
        try container.encodeIfPresent(scopes, forKey: .scopes)
    }
}
