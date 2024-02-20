import Foundation
import ArgumentParser
import GoogleGen
import SharedKit

@main
struct Cmd: AsyncParsableCommand {
    
    static var configuration = CommandConfiguration(
        abstract: "A utility for interacting with the GoogleGen API.",
        version: "0.0.1",
        subcommands: [
            ChatCompletion.self,
        ]
    )
}

struct Options: ParsableArguments {
    @Option(help: "Your API token.")
    var token = ""
    
    @Option(help: "Model to use.")
    var model = ""
    
    @Argument(help: "Your messages.")
    var prompt = ""
}

struct ChatCompletion: AsyncParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Completes a chat request.")
    
    @OptionGroup var options: Options
    
    func run() async throws {
        let client = GoogleGenClient(token: options.token)
        let query = GenerateContentRequest(contents: [.init(role: "user", parts: [.init(text: options.prompt)])])
        let resp = try await client.chat(query, model: "gemini-pro")
        print(resp)
        
//        let client = ElevenLabsClient(token: options.token)
//        let query = TextToSpeechQuery(text: options.prompt)
//        let data = try await client.textToSpeech(query, voice: "21m00Tcm4TlvDq8ikWAM")
//        let filename = "\(String.id).mp3"
//        
//        if let url = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first?.appending(component: filename) {
//            try data.write(to: url)
//            try FileHandle.standardOutput.write(contentsOf: url.absoluteString.data(using: .utf8)!)
//        } else {
//            print("unable to create URL")
//        }
    }
}
