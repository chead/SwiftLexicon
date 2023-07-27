//
//  Lexicon.swift
//  
//
//  Created by Christopher Head on 7/18/23.
//

import Foundation

protocol LexiconFieldRepresentable: Decodable, Hashable {
    var description: String? { get }
}

protocol LexiconSchemaRepresentable: Decodable {}

public struct LexiconNullField: LexiconFieldRepresentable {
    private enum CodingKeys: CodingKey {
        case description
    }
    
    public let description: String?
}

public struct LexiconBooleanField: LexiconFieldRepresentable {
    private enum CodingKeys: CodingKey {
        case description
        case `default`
        case const
    }

    public let description: String?
    public let `default`: Bool?
    public let const: Bool?
}

public struct LexiconIntegerField: LexiconFieldRepresentable {
    public let description: String?
    public let minimum: Int?
    public let maxmimum: Int?
    public let `enum`: Set<Int>?
    public let `default`: Int?
    public let const: Int?
}

public struct LexiconStringField: LexiconFieldRepresentable {
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

public struct LexiconBytesField: LexiconFieldRepresentable {
    public let description: String?
    public let maxLength: Int?
    public let minLength: Int?
}

public struct LexiconCIDLinkField: LexiconFieldRepresentable {
    public let description: String?
}

public struct LexiconArrayField: LexiconFieldRepresentable {    
    public let description: String?
    public let items: LexiconField
    public let maxLength: Int?
    public let minLength: Int?
}

public struct LexiconObjectField: LexiconFieldRepresentable, LexiconSchemaRepresentable {
    public let description: String?
    public let properties: [String : LexiconField]
    public let required: [String]?
    public let nullable: [String]?
}

public struct LexiconBlobField: LexiconFieldRepresentable {
    public let description: String?
    public let accept: [String]?
    public let maxSize: Int?
}

public struct LexiconParamsField: LexiconFieldRepresentable {
    public let description: String?
    public let required: [String]?

    // Can only include the types boolean, integer, string, and unknown; or an array of one of these types
    public let properties: [String : LexiconField]
}

public struct LexiconTokenField: LexiconFieldRepresentable {
    public let description: String?
}

public struct LexiconRefField: LexiconFieldRepresentable, LexiconSchemaRepresentable {
    public let description: String?
    public let ref: String
}

public struct LexiconUnionField: LexiconFieldRepresentable, LexiconSchemaRepresentable {
    public let description: String?
    public let refs: [String]
    public let closed: Bool?
}

public struct LexiconUnknownField: LexiconFieldRepresentable {
    public let description: String?
}

public indirect enum LexiconField: Decodable, Hashable {
    public static func == (lhs: LexiconField, rhs: LexiconField) -> Bool {
        switch(lhs, rhs) {
        case(null(let lhsNullField), null(let rhsNullField)):
            return lhsNullField == rhsNullField

        case(boolean(let lhsBooleanField), boolean(let rhsBooleanField)):
            return lhsBooleanField == rhsBooleanField

        case(integer(let lhsIntegerField), integer(let rhsIntegerField)):
            return lhsIntegerField == rhsIntegerField

        case(string(let lhsStringField), string(let rhsStringField)):
            return lhsStringField == rhsStringField

        case(bytes(let lhsBytesField), bytes(let rhsBytesField)):
            return lhsBytesField == rhsBytesField

        case(cidLink(let lhsCIDLinkField), cidLink(let rhsCIDLinkField)):
            return lhsCIDLinkField == rhsCIDLinkField

        case(array(let lhsArrayField), array(let rhsArrayField)):
            return lhsArrayField == rhsArrayField

        case(object(let lhsObjectField), object(let rhsObjectField)):
            return lhsObjectField == rhsObjectField

        case(params(let lhsParamsField), params(let rhsParamsField)):
            return lhsParamsField == rhsParamsField

        case(token(let lhsTokenField), token(let rhsTokenField)):
            return lhsTokenField == rhsTokenField

        case(ref(let lhsRefField), ref(let rhsRefField)):
            return lhsRefField == rhsRefField
            
        case(union(let lhsUnionField), union(let rhsUnionField)):
            return lhsUnionField == rhsUnionField

        case(unknown(let lhsUnknownField), unknown(let rhsUnknownField)):
            return lhsUnknownField == rhsUnknownField
            
        default:
            return false
        }
    }

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .null(let nullField):
            hasher.combine(nullField)

        case .boolean(let booleanField):
            hasher.combine(booleanField)

        case .integer(let integerField):
            hasher.combine(integerField)

        case .string(let stringField):
            hasher.combine(stringField)

        case .bytes(let bytesField):
            hasher.combine(bytesField)

        case .cidLink(let cidLinkField):
            hasher.combine(cidLinkField)

        case .array(let arrayField):
            hasher.combine(arrayField)

        case .object(let objectField):
            hasher.combine(objectField)

        case .params(let paramsField):
            hasher.combine(paramsField)

        case .token(let tokenField):
            hasher.combine(tokenField)
        
        case .ref(let refField):
            hasher.combine(refField)

        case .union(let unionField):
            hasher.combine(unionField)

        case .unknown(let unknownField):
            hasher.combine(unknownField)
        }
    }

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
    var errors: [LexiconError]? { get }
}

public struct LexiconQuery: LexiconPrimaryTypeRepresentable, LexiconHTTPRequestable, Decodable {
    public let description: String?
    public let parameters: LexiconParamsField?
    public let output: LexiconHTTPBodyDescription?
    public let input: LexiconHTTPBodyDescription?
    public let errors: [LexiconError]?
}

public struct LexiconProcedure: LexiconPrimaryTypeRepresentable, LexiconHTTPRequestable, Decodable {
    public let description: String?
    public let parameters: LexiconParamsField?
    public let output: LexiconHTTPBodyDescription?
    public let input: LexiconHTTPBodyDescription?
    public let errors: [LexiconError]?
}

public struct LexiconSubscriptionMessage: Decodable {
    public let description: String?
    public let schema: LexiconUnionField
}

public struct LexiconSubscription: LexiconPrimaryTypeRepresentable, Decodable {
    public let description: String?
    public let parameters: LexiconParamsField?
    public let message: LexiconSubscriptionMessage?
    public let errors: [LexiconError]?
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
