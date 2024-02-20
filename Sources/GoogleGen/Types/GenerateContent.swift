import Foundation

// Requests

public struct GenerateContentRequest: Codable {
    public var contents: [Content]
    public var tools: [Tool]?
    public var generationConfig: GenerationConfig?
    
    public init(contents: [Content], tools: [Tool]? = nil, generationConfig: GenerationConfig? = nil) {
        self.contents = contents
        self.tools = tools
        self.generationConfig = generationConfig
    }
}

public struct Content: Codable {
    public var role: String?
    public var parts: [Part]
    
    public struct Part: Codable {
        public var text: String
        public var inlineData: Blob?
        public var functionCall: FunctionCall?
        public var functionResponse: FunctionResponse?
        
        public struct Blob: Codable {
            public var mimeType: String
            public var data: String
            
            public init(mimeType: String, data: String) {
                self.mimeType = mimeType
                self.data = data
            }
        }
        
        public struct FunctionCall: Codable {
            public var name: String
            public var args: JSONSchema
            
            public init(name: String, args: JSONSchema) {
                self.name = name
                self.args = args
            }
        }
        
        public struct FunctionResponse: Codable {
            public var name: String
            public var response: JSONSchema
            
            public init(name: String, response: JSONSchema) {
                self.name = name
                self.response = response
            }
        }
        
        public init(text: String, inlineData: Blob? = nil, functionCall: FunctionCall? = nil, functionResponse: FunctionResponse? = nil) {
            self.text = text
            self.inlineData = inlineData
            self.functionCall = functionCall
            self.functionResponse = functionResponse
        }
    }
    
    public init(role: String? = nil, parts: [Part]) {
        self.role = role
        self.parts = parts
    }
}

public struct Tool: Codable {
    public var functionDeclarations: [FunctionDeclaration]
    
    public struct FunctionDeclaration: Codable {
        public var name: String
        public var description: String
        public var parameters: JSONSchema?
        
        public init(name: String, description: String, parameters: JSONSchema? = nil) {
            self.name = name
            self.description = description
            self.parameters = parameters
        }
    }
    
    public init(functionDeclarations: [FunctionDeclaration]) {
        self.functionDeclarations = functionDeclarations
    }
}

public struct GenerationConfig: Codable {
    public var stopSequences: [String]?
    public var candidateCount: Int?
    public var maxOutputTokens: Int?
    public var temperature: Double?
    public var topP: Double?
    public var topK: Double?
    
    public init(stopSequences: [String]? = nil, candidateCount: Int? = nil, maxOutputTokens: Int? = nil, temperature: Double? = nil, topP: Double? = nil, topK: Double? = nil) {
        self.stopSequences = stopSequences
        self.candidateCount = candidateCount
        self.maxOutputTokens = maxOutputTokens
        self.temperature = temperature
        self.topP = topP
        self.topK = topK
    }
}

// Responses

public struct GenerateContentResponse: Codable {
    public let candidates: [Candidate]
}

public struct Candidate: Codable {
    public let content: Content
    public let finishReason: FinishReason?
    public let tokenCount: Int?
    public let index: Int
    
    public enum FinishReason: String, Codable {
        case unspecified = "FINISH_REASON_UNSPECIFIED"
        case stop = "STOP"
        case maxTokens = "MAX_TOKENS"
        case safety = "SAFETY"
        case recitation = "RECITATION"
        case other = "OTHER"
    }
}
