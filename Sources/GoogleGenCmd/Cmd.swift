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
            ChatStreamCompletion.self
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
        let client = GoogleGenClient(configuration: .init(token: options.token))
        let query = GenerateContentRequest(contents: [.init(role: "user", parts: [.init(text: options.prompt)])])
        let resp = try await client.chat(query, model: Defaults.chatModel)
        let text = resp.candidates.map { candidate in
            candidate.content.parts.map { $0.text }.joined()
        }.joined()
        try FileHandle.standardOutput.write(contentsOf: text.data(using: .utf8)!)
    }
}

struct ChatStreamCompletion: AsyncParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Completes a chat request, streaming the response.")
    
    @OptionGroup var options: Options
    
    func run() async throws {
        let client = GoogleGenClient(configuration: .init(token: options.token))
        let query = GenerateContentRequest(contents: [.init(role: "user", parts: [.init(text: options.prompt)])])
        let stream: AsyncThrowingStream<GenerateContentResponse, Error> = client.chatStream(query, model: Defaults.chatModel)
        for try await result in stream {
            let text = result.candidates.map { candidate in
                candidate.content.parts.map { $0.text }.joined()
            }.joined()
            try FileHandle.standardOutput.write(contentsOf: text.data(using: .utf8)!)
        }
    }
}
