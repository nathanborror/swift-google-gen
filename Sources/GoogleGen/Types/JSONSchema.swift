import Foundation

/// See the [guide](/docs/guides/gpt/function-calling) for examples, and the [JSON Schema reference](https://json-schema.org/understanding-json-schema/) for documentation about the format.
public struct JSONSchema: Codable, Equatable {
    public let type: JSONType
    public let properties: [String: Property]?
    public let required: [String]?
    public let pattern: String?
    public let const: String?
    public let enumValues: [String]?
    public let multipleOf: Int?
    public let minimum: Int?
    public let maximum: Int?
    
    private enum CodingKeys: String, CodingKey {
        case type, properties, required, pattern, const
        case enumValues = "enum"
        case multipleOf, minimum, maximum
    }
    
    public struct Property: Codable, Equatable {
        public let type: JSONType
        public let description: String?
        public let format: String?
        public let items: Items?
        public let required: [String]?
        public let pattern: String?
        public let const: String?
        public let enumValues: [String]?
        public let multipleOf: Int?
        public let minimum: Double?
        public let maximum: Double?
        public let minItems: Int?
        public let maxItems: Int?
        public let uniqueItems: Bool?

        private enum CodingKeys: String, CodingKey {
            case type, description, format, items, required, pattern, const
            case enumValues = "enum"
            case multipleOf, minimum, maximum
            case minItems, maxItems, uniqueItems
        }
        
        public init(type: JSONType, description: String? = nil, format: String? = nil, items: Items? = nil, required: [String]? = nil, pattern: String? = nil, const: String? = nil, enumValues: [String]? = nil, multipleOf: Int? = nil, minimum: Double? = nil, maximum: Double? = nil, minItems: Int? = nil, maxItems: Int? = nil, uniqueItems: Bool? = nil) {
            self.type = type
            self.description = description
            self.format = format
            self.items = items
            self.required = required
            self.pattern = pattern
            self.const = const
            self.enumValues = enumValues
            self.multipleOf = multipleOf
            self.minimum = minimum
            self.maximum = maximum
            self.minItems = minItems
            self.maxItems = maxItems
            self.uniqueItems = uniqueItems
        }
    }

    public enum JSONType: String, Codable {
        case integer = "integer"
        case string = "string"
        case boolean = "boolean"
        case array = "array"
        case object = "object"
        case number = "number"
        case `null` = "null"
    }

    public struct Items: Codable, Equatable {
        public let type: JSONType
        public let properties: [String: Property]?
        public let pattern: String?
        public let const: String?
        public let enumValues: [String]?
        public let multipleOf: Int?
        public let minimum: Double?
        public let maximum: Double?
        public let minItems: Int?
        public let maxItems: Int?
        public let uniqueItems: Bool?

        private enum CodingKeys: String, CodingKey {
            case type, properties, pattern, const
            case enumValues = "enum"
            case multipleOf, minimum, maximum, minItems, maxItems, uniqueItems
        }
        
        public init(type: JSONType, properties: [String : Property]? = nil, pattern: String? = nil, const: String? = nil, enumValues: [String]? = nil, multipleOf: Int? = nil, minimum: Double? = nil, maximum: Double? = nil, minItems: Int? = nil, maxItems: Int? = nil, uniqueItems: Bool? = nil) {
            self.type = type
            self.properties = properties
            self.pattern = pattern
            self.const = const
            self.enumValues = enumValues
            self.multipleOf = multipleOf
            self.minimum = minimum
            self.maximum = maximum
            self.minItems = minItems
            self.maxItems = maxItems
            self.uniqueItems = uniqueItems
        }
    }
    
    public init(type: JSONType, properties: [String : Property]? = nil, required: [String]? = nil, pattern: String? = nil, const: String? = nil, enumValues: [String]? = nil, multipleOf: Int? = nil, minimum: Int? = nil, maximum: Int? = nil) {
        self.type = type
        self.properties = properties
        self.required = required
        self.pattern = pattern
        self.const = const
        self.enumValues = enumValues
        self.multipleOf = multipleOf
        self.minimum = minimum
        self.maximum = maximum
    }
}
