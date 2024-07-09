import Alamofire
import Combine
import Foundation

class OpenAIService {
    let baseUrl = "https://api.openai.com/v1/chat/completions"
    
    func sendMessage(message: String) -> AnyPublisher<OpenAICompletionsResponse, Error> {
        let messages = [
            ["role": "system", "content": "You are a helpful assistant."],
            ["role": "user", "content": message]
        ]
        let body = OpenAIChatCompletionsBody(model: "gpt-3.5-turbo", messages: messages, temperature: 0.7)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.openAIKey)"
        ]
        
        return Future { [weak self] promise in
            guard let self = self else { return }
            AF.request(self.baseUrl, method: .post, parameters: body, encoder: .json, headers: headers)
                .responseDecodable(of: OpenAICompletionsResponse.self) { response in
                    switch response.result {
                    case .success(let result):
                        promise(.success(result))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }.eraseToAnyPublisher()
    }
}

struct OpenAIChatCompletionsBody: Encodable {
    let model: String
    let messages: [[String: String]]
    let temperature: Float?
}

struct OpenAICompletionsResponse: Decodable {
    let choices: [OpenAICompletionsChoice]
}

struct OpenAICompletionsChoice: Decodable {
    let message: OpenAIMessage
}

struct OpenAIMessage: Decodable {
    let role: String
    let content: String
}
