import Foundation

public struct Defaults {
    
    public static let apiHost = URL(string: "https://generativelanguage.googleapis.com/v1beta")!
    
    public static let chatModel = "gemini-pro"
    
    public static let models: [String] = [
        chatModel,
    ]
}
