//
//  ChatHistoryViewModel.swift
//  AIAssistant
//
//  Created by  吴 熠 on 2023/10/24.
//

import Foundation

class ChatHistoryViewModel: ObservableObject {
    @Published var hisQuestions: [MessageModel] = []
    
    // 加载历史
    func loadHisQuestions() {
        hisQuestions = []
        let questions: [MessageModel] = ChatManager.getObjectArray(key: Store.QUESTIONS_STORE_KEY)
        for question in questions {
            hisQuestions.append(question)
        }
    }
    
    // 查询回答
    func getAnswer(questionId: String) -> String {
        let answer: String = ChatManager.getString(key: questionId)
        // print("查询问题:问题id=\(questionId),问题内容=\(answer)")
        return answer
    }
    
    // 保存聊天
    func saveAnswer(questionText: String, answerText: String) {
        // 存储问题
        let question = MessageModel(role: .me, content: questionText, status: .finished)
        var questions: [MessageModel] = ChatManager.getObjectArray(key: Store.QUESTIONS_STORE_KEY)
        questions.append(question)
        ChatManager.setObjectArray(key: Store.QUESTIONS_STORE_KEY, objectArray: questions)
        // print("存储问题:问题id=\(question.id.uuidString),问题内容=\(questionText)")
        
        // 存储答案
        ChatManager.set(key: question.id.uuidString, value: answerText)
        // let value = UserDefManager.getString(key: question.id.uuidString)
        // print("存储回答:问题id=\(question.id.uuidString),回答内容=\(value)")
    }
}
