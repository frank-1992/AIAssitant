//
//  ChatViewModel.swift
//  AIAssistant
//
//  Created by  吴 熠 on 2023/10/24.
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var secretKey: String = Config.SECRET_KEY
    @Published var messages: [MessageModel] = [MessageModel(role: .robot, content: "您的专属AI助手已上线", status: .finished)]
    @Published var showErrorBox: Bool = false
    @Published var errorMessage: String = ""
    
    private let network: Network
    @Published var messageText: String = ""
    
    init(network: Network) {
        self.network = network
    }
    
    @MainActor
    func retry(text: String) async {
        await send(text: text)
    }
    
    @MainActor
    private func send(text: String) async {
        self.messages.append(MessageModel(role: .robot, content: "思考中...", status: .loading))
        do {
            var context = ""
            if self.messages.count >= 2{
                context = self.messages[self.messages.count - 2].content
            }
            let stream = try await network.sendMessageStream(text: text, context: context)
            var responseText = ""
            for try await text in stream {
                responseText += text
                self.messages.removeLast()
                self.messages.append(MessageModel(role: .robot, content: responseText, status: .sending))
            }
        } catch {
            self.messages.removeLast()
            self.messages.append(MessageModel(role: .robot, content: "网络异常，请检查网络配置！", status: .error))
            return
        }
        let lastMessage = self.messages.last
        self.messages.removeLast()
        self.messages.append(MessageModel(role: .robot, content: lastMessage?.content ?? "", status: .finished))
    }
}
