import SwiftUI
import Alamofire
import Combine

struct ChatbotView: View {
    @StateObject private var viewModel: ChatbotViewModel
    
    init(fearId: String) {
        _viewModel = StateObject(wrappedValue: ChatbotViewModel(fearId: fearId))
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.chatMessages) { message in
                        messageView(message: message)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.sendMessage()
        }
    }
    
    func messageView(message: ChatMessage) -> some View {
        HStack {
            if message.sender == .me { Spacer() }
            Text(message.content)
                .foregroundColor(.white)
                .padding()
                .background(Color.black)
                .cornerRadius(16)
            if message.sender == .gpt {
                Spacer()
            }
        }
    }
}

class ChatbotViewModel: ObservableObject {
    @Published var chatMessages: [ChatMessage] = []
    @Published var messageText: String = ""
    private var cancellables = Set<AnyCancellable>()
    private let openAIServices = OpenAIService()
    private let fearId: String
    
    init(fearId: String) {
        self.fearId = fearId
    }
    
    func sendMessage() {
        let prompt = "can you help me get over my fear of \(fearId), include some resources"
        let newMessage = ChatMessage(id: UUID().uuidString, content: prompt, dateCreated: Date(), sender: .me)
        chatMessages.append(newMessage)
        
        openAIServices.sendMessage(message: prompt)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error sending message: \(error)")
                }
            }, receiveValue: { response in
                if let gptResponse = response.choices.first?.message.content.trimmingCharacters(in: .whitespacesAndNewlines) {
                    DispatchQueue.main.async {
                        let gptMessage = ChatMessage(id: UUID().uuidString, content: gptResponse, dateCreated: Date(), sender: .gpt)
                        self.chatMessages.append(gptMessage)
                    }
                }
            })
            .store(in: &cancellables)
        
        messageText = ""
    }
}

struct ChatMessage: Identifiable {
    let id: String
    let content: String
    let dateCreated: Date
    let sender: MessageSender
}

enum MessageSender {
    case me
    case gpt
}
