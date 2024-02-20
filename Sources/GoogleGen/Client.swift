import Foundation
import SharedKit

public final class GoogleGenClient {
    
    public struct Configuration {
        public let host: URL
        public let token: String
        
        public init(host: URL = URL(string: "https://generativelanguage.googleapis.com/v1beta")!, token: String) {
            self.host = host
            self.token = token
        }
    }
    
    public let configuration: Configuration
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    public convenience init(token: String) {
        self.init(configuration: .init(token: token))
    }
    
    // Chats
    
    public func chat(_ payload: GenerateContentRequest, model: String) async throws -> GenerateContentResponse {
        var req = makeRequest(path: "models/\(model):generateContent", method: "POST")
        req.httpBody = try JSONEncoder().encode(payload)
        
        let (data, resp) = try await URLSession.shared.data(for: req)
        if let httpResponse = resp as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw URLError(.badServerResponse)
        }
        return try decoder.decode(GenerateContentResponse.self, from: data)
    }
    
    public func chatStream(_ payload: GenerateContentRequest, model: String) -> AsyncThrowingStream<GenerateContentResponse, Error> {
        return makeAsyncRequest(path: "models/\(model):streamGenerateContent", method: "POST", body: payload)
    }
    
    // Models
    
    public func models() async throws -> ModelListResponse {
        .init(
            models: [
                "gemini-pro",
            ]
        )
    }
    
    // Private
    
    private func makeRequest(path: String, method: String) -> URLRequest {
        var req = URLRequest(url: configuration.host.appending(path: path))
        req.httpMethod = method
        req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        req.queryParameters["key"] = configuration.token
        return req
    }
    
    private func makeAsyncRequest<Body: Codable, Response: Codable>(path: String, method: String, body: Body) -> AsyncThrowingStream<Response, Error> {
        var request = makeRequest(path: path, method: method)
        request.httpBody = try? JSONEncoder().encode(body)
        
        return AsyncThrowingStream { continuation in
            let session = StreamingSession<Response>(urlRequest: request)
            session.onReceiveContent = {_, object in
                continuation.yield(object)
            }
            session.onProcessingError = {_, error in
                continuation.finish(throwing: error)
            }
            session.onComplete = { object, error in
                continuation.finish(throwing: error)
            }
            session.perform()
        }
    }
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
}
