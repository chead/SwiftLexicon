//
//  Lexicon.swift
//  
//
//  Created by Christopher Head on 7/18/23.
//

import Foundation

protocol LexiconFieldTypeRepresentable: Decodable {
    var description: String? { get }
}

protocol LexiconSchemaRepresentable: Decodable {}

public struct LexiconNullField: LexiconFieldTypeRepresentable {
    private enum CodingKeys: CodingKey {
        case description
    }
    
    public let description: String?
}

public struct LexiconBooleanField: LexiconFieldTypeRepresentable {
    private enum CodingKeys: CodingKey {
        case description
        case `default`
        case const
    }

    public let description: String?
    public let `default`: Bool?
    public let const: Bool?
}

public struct LexiconIntegerField: LexiconFieldTypeRepresentable {
    public let description: String?
    public let minimum: Int?
    public let maxmimum: Int?
    public let `enum`: Set<Int>?
    public let `default`: Int?
    public let const: Int?
}

public struct LexiconStringField: LexiconFieldTypeRepresentable {
    public let description: String?
    public let format: String?
    public let maxLength: Int?
    public let minLength: Int?
    public let maxGraphemes: Int?
    public let minGraphemes: Int?
    public let knownValues: [String]?
    public let `enum`: Set<String>?
    public let `default`: String?
    public let const: String?
}

public struct LexiconBytesField: LexiconFieldTypeRepresentable {
    public let description: String?
    public let maxLength: Int?
    public let minLength: Int?
}

public struct LexiconCIDLinkField: LexiconFieldTypeRepresentable {
    public let description: String?
}

public enum LexiconSchemaField: Decodable {
    private enum FieldType: String, Decodable {
        case ref
        case union
    }

    private enum CodingKeys: CodingKey {
        case type
    }

    case ref(LexiconRefField)
    case union(LexiconUnionField)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fieldType = try container.decode(FieldType.self, forKey: .type)
        
        let singleValueContainer = try decoder.singleValueContainer()

        switch fieldType {
        case .ref:
            try self = .ref(singleValueContainer.decode(LexiconRefField.self))
        case .union:
            try self = .union(singleValueContainer.decode(LexiconUnionField.self))
        }
    }
}

public struct LexiconArrayField: LexiconFieldTypeRepresentable {
    public let description: String?
    public let items: LexiconSchemaField
    public let maxLength: Int?
    public let minLength: Int?
}

public struct LexiconObjectField: LexiconFieldTypeRepresentable, LexiconSchemaRepresentable {
    public let description: String?
    public let properties: [String : LexiconFieldType]
    public let required: [String]?
    public let nullable: [String]?
}

public struct LexiconBlobField: LexiconFieldTypeRepresentable {
    public let description: String?
    public let accept: [String]?
    public let maxSize: Int?
}

public struct LexiconParamsField: LexiconFieldTypeRepresentable {
    public let description: String?
    public let required: [String]?

    // Can only include the types boolean, integer, string, and unknown; or an array of one of these types
    public let properties: [String : LexiconFieldType]
}

public struct LexiconTokenField: LexiconFieldTypeRepresentable {
    public let description: String?
}

public struct LexiconRefField: LexiconFieldTypeRepresentable, LexiconSchemaRepresentable {
    public let description: String?
    public let ref: String
}

public struct LexiconUnionField: LexiconFieldTypeRepresentable, LexiconSchemaRepresentable {
    public let description: String?
    public let refs: [String]
    public let closed: Bool?
}

public struct LexiconUnknownField: LexiconFieldTypeRepresentable {
    public let description: String?
}

public enum LexiconFieldType: Decodable {
    private enum FieldType: String, Decodable {
        case null
        case boolean
        case integer
        case string
        case bytes
        case cidLink = "cid-link"
        case array
        case object
        case params
        case token
        case ref
        case union
        case unknown
    }

    private enum CodingKeys: CodingKey {
        case type
    }

    case null(LexiconNullField)
    case boolean(LexiconBooleanField)
    case integer(LexiconIntegerField)
    case string(LexiconStringField)
    case bytes(LexiconBytesField)
    case cidLink(LexiconCIDLinkField)
    case array(LexiconArrayField)
    case object(LexiconObjectField)
    case params(LexiconParamsField)
    case token(LexiconTokenField)
    case ref(LexiconRefField)
    case union(LexiconUnionField)
    case unknown(LexiconUnknownField)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fieldType = try container.decode(FieldType.self, forKey: .type)

        let singleValueContainer = try decoder.singleValueContainer()
        
        switch fieldType {
        case .null:
            try self = .null(singleValueContainer.decode(LexiconNullField.self))
        
        case .boolean:
            try self = .boolean(singleValueContainer.decode(LexiconBooleanField.self))

        case .integer:
            try self = .integer(singleValueContainer.decode(LexiconIntegerField.self))

        case .string:
            try self = .string(singleValueContainer.decode(LexiconStringField.self))

        case .bytes:
            try self = .bytes(singleValueContainer.decode(LexiconBytesField.self))

        case .cidLink:
            try self = .cidLink(singleValueContainer.decode(LexiconCIDLinkField.self))

        case .array:
            try self = .array(singleValueContainer.decode(LexiconArrayField.self))

        case .object:
            try self = .object(singleValueContainer.decode(LexiconObjectField.self))

        case .params:
            try self = .params(singleValueContainer.decode(LexiconParamsField.self))

        case .token:
            try self = .token(singleValueContainer.decode(LexiconTokenField.self))

        case .ref:
            try self = .ref(singleValueContainer.decode(LexiconRefField.self))

        case .union:
            try self = .union(singleValueContainer.decode(LexiconUnionField.self))
            
        case .unknown:
            try self = .unknown(singleValueContainer.decode(LexiconUnknownField.self))
        }
    }
}

public enum LexiconSchemaType: Decodable {
    private enum FieldType: String, Decodable {
        case object
        case ref
        case union
    }

    private enum CodingKeys: CodingKey {
        case type
    }

    case object(LexiconObjectField)
    case ref(LexiconRefField)
    case union(LexiconUnionField)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fieldType = try container.decode(FieldType.self, forKey: .type)
        
        let singleValueContainer = try decoder.singleValueContainer()
        
        switch fieldType {
        case .object:
            try self = .object(singleValueContainer.decode(LexiconObjectField.self))
        case .ref:
            try self = .ref(singleValueContainer.decode(LexiconRefField.self))
        case .union:
            try self = .union(singleValueContainer.decode(LexiconUnionField.self))
        }
    }
}

public struct LexiconHTTPBodyDescription: Decodable {
    public let description: String?
    public let encoding: String
    public let schema: LexiconSchemaType
}

public struct LexiconError: Decodable {
    public let name: String
    public let description: String?
}

public protocol LexiconPrimaryTypeRepresentable {
    var description: String? { get }
}

public enum LexiconPrimaryType: Decodable {
    private enum FieldType: String, Decodable {
        case query
        case procedure
        case subscription
        case record
    }

    private enum CodingKeys: CodingKey {
        case type
    }

    case query(LexiconQuery)
    case procedure(LexiconProcedure)
    case subscription(LexiconSubscription)
    case record(LexiconRecord)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fieldType = try container.decode(FieldType.self, forKey: .type)
        
        let singleValueContainer = try decoder.singleValueContainer()
        
        switch fieldType {
        case .query:
            try self = .query(singleValueContainer.decode(LexiconQuery.self))
        case .procedure:
            try self = .procedure(singleValueContainer.decode(LexiconProcedure.self))
        case .subscription:
            try self = .subscription(singleValueContainer.decode(LexiconSubscription.self))
        case .record:
            try self = .record(singleValueContainer.decode(LexiconRecord.self))
        }
    }
}

public protocol LexiconHTTPRequestable {
    var parameters: LexiconParamsField? { get }
    var output: LexiconHTTPBodyDescription? { get }
    var input: LexiconHTTPBodyDescription? { get }
    var errors: LexiconError? { get }
}

public struct LexiconQuery: LexiconPrimaryTypeRepresentable, LexiconHTTPRequestable, Decodable {
    public let description: String?
    public let parameters: LexiconParamsField?
    public let output: LexiconHTTPBodyDescription?
    public let input: LexiconHTTPBodyDescription?
    public let errors: LexiconError?
}

public struct LexiconProcedure: LexiconPrimaryTypeRepresentable, LexiconHTTPRequestable, Decodable {
    public let description: String?
    public let parameters: LexiconParamsField?
    public let output: LexiconHTTPBodyDescription?
    public let input: LexiconHTTPBodyDescription?
    public let errors: LexiconError?
}

public struct LexiconSubscriptionMessage: Decodable {
    public let description: String?
    public let schema: LexiconUnionField
}

public struct LexiconSubscription: LexiconPrimaryTypeRepresentable, Decodable {
    public let description: String?
    public let parameters: LexiconParamsField?
    public let message: LexiconSubscriptionMessage?
    public let errors: LexiconError?
}

public struct LexiconRecord: LexiconPrimaryTypeRepresentable, Decodable {
    public let description: String?
    public let key: String
    public let record: LexiconObjectField
}

public struct Lexicon: Decodable {
    public let lexicon: Int
    public let id: String
    public let revision: Int?
    public let description: String?
    public let defs: [String : LexiconPrimaryType]
}
