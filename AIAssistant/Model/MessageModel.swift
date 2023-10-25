//
//  MessageModel.swift
//  AIAssistant
//
//  Created by  吴 熠 on 2023/10/24.
//

import Foundation


struct MessageModel: Identifiable, Hashable, Codable {
    var id = UUID()
    var role: MessageRole
    var content: String
    var status: MessageStatus
    var date = Date()
}

enum MessageRole: Codable {
    case me
    case robot
}

extension MessageRole {
    var isMe: Bool {
        switch self {
        case .me:
            return true
        case .robot:
            return false
        }
    }
    
    var name: String {
        switch self {
        case .me:
            return "我"
        case .robot:
            return "Robot"
        }
    }
    
    var imageName: String {
        switch self {
        case .me:
            return "User"
        case .robot:
            return "Robot"
        }
    }
}

enum MessageStatus: String, Codable {
    case loading = "加载中..."
    case sending = "发送中..."
    case finished = "已结束"
    case error = "Error"
}
