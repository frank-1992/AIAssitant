//
//  ChatHistoryView.swift
//  AIAssistant
//
//  Created by  吴 熠 on 2023/10/24.
//

import SwiftUI

struct ChatHistoryView: View {
    @StateObject var historyVM = ChatHistoryViewModel()
    @State var showAlert: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(historyVM.hisQuestions, id: \.id) { question in
                    NavigationLink {
                        answerView(question: question)
                    } label: {
                        HStack {
                            Text(question.content)
                                .lineLimit(3)
                            Spacer()
                            Text(dateString(date: question.date))
                                .font(.system(.subheadline))
                                .foregroundColor(.gray)
                        }
                    }
                    
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("聊天记录")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                historyVM.loadHisQuestions()
            }
        }
        // 解决在iPad上视图被折叠问题
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

extension ChatHistoryView {
    func answerView(question: MessageModel) -> some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("问题：\(question.content)")
                        .font(.system(.headline))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    Text(historyVM.getAnswer(questionId: question.id.uuidString))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.cyan.opacity(0.5))
                }
                .padding()
                .onTapGesture {
                    let copyText = """
                    问题：\(question.content)\n
                    \(historyVM.getAnswer(questionId: question.id.uuidString))\n
                    """
                    let pastebord = UIPasteboard.general
                    pastebord.string = copyText
                    showAlert.toggle()
                }
            }
        }
        .navigationTitle(question.content)
    }
}

func dateString(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let dateString = formatter.string(from: date)
    return dateString
}


#Preview {
    ChatHistoryView()
}
