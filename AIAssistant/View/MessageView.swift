//
//  MessageView.swift
//  AIAssistant
//
//  Created by  吴 熠 on 2023/10/24.
//

import SwiftUI

struct MessageView: View {
    @State var message: MessageModel
    
    var body: some View {
        HStack {
            // robot，则靠右对齐
            if !message.role.isMe {
                Spacer()
            }
            VStack(alignment: message.role.isMe ? .leading : .trailing, spacing: 5) {
                HStack(alignment: .center, spacing: 8) {
                    if message.role.isMe {
                        Image(message.role.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                        Text(message.role.name)
                            .font(.system(.headline))
                            .foregroundColor(.gray)
                    } else {
                        Text(message.role.name)
                            .font(.system(.headline))
                            .foregroundColor(.gray)
                        Image(message.role.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                    }
                }
                HStack {
                    if message.role.isMe {
                        Text(message.content)
                    } else {
                        if message.status == .loading {
                            HStack(spacing: 10) {
                                Text("加载中...")
                                ProgressView()
                            }
                        } else if message.status == .error {
                            HStack(spacing: 10) {
                                Text("网络请求失败")
                                    .foregroundColor(.red)
                            }
                        } else {
                            Text(message.content)
                        }
                    }
                }
                .padding()
                .foregroundColor(.primary)
                .background(message.role.isMe ? .gray.opacity(0.1) : .cyan.opacity(0.5))
                .cornerRadius(10)
            }
            // user，靠左对齐
            if message.role.isMe {
                Spacer()
            }
        }
        .id(message.id)
        .padding(.bottom, message.role.isMe ? 20 : 50)
    }
}

#Preview {
    MessageView(
        message: MessageModel(role: .robot, content: "加载中", status: .loading)
    )
}
