//
//  ChatView.swift
//  AIAssistant
//
//  Created by  吴 熠 on 2023/10/24.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var vm: ChatViewModel
    @State var inputText: String = ""
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            messageListView
                .navigationTitle("聊天")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var messageListView: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(vm.messages, id: \.id) { message in
                            MessageView(message: message)
                        }
                        .onAppear {
                            if ((vm.messages.last?.id) != nil) {
                                withAnimation {
                                    proxy.scrollTo(vm.messages.last?.id, anchor: .bottom)
                                }
                            }
                        }
                        .onChange(of: vm.messages) { (value) in
                            withAnimation {
                                proxy.scrollTo(value.last?.id, anchor: .bottom)
                            }
                        }
                    }
                }
                .background(Color.clear)
                .padding(.horizontal, 20)
                .gesture(
                    DragGesture()
                        .onChanged({ gesture in
                            let dragType = detectDrag(end: gesture.predictedEndLocation, start: gesture.location)
                            if dragType == .TopToBottom || dragType == .BottomToTop {
                                isTextFieldFocused = false
                            }
                        })
                )
                .onTapGesture {
                    isTextFieldFocused = false
                }
                
                Divider()
                
                // 消息输入框
                HStack {
                    TextField("请输入。。。", text: $inputText, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($isTextFieldFocused)
                        .onTapGesture {
                            withAnimation {
                                proxy.scrollTo(vm.messages.last?.id, anchor: .bottom)
                            }
                        }
                    Button {
                        if inputText.isEmpty {
                            return
                        }
                        
                        print(" 输入内容:\(inputText)")
                        
                        let secretKey = Config.SECRET_KEY
                        vm.secretKey = secretKey.trimmingCharacters(in: .whitespacesAndNewlines)
                        if vm.secretKey.isEmpty {
                            vm.errorMessage = "缺少api secret key"
                            vm.showErrorBox = true
                            return
                        }
                        vm.messageText = ""
                        vm.messages.append(MessageModel(role: .me, content: inputText, status: .finished))
                        let inputMessage = inputText
                        inputText = ""
                        Task { @MainActor in
                            await vm.retry(text: inputMessage)
                        }
                    } label: {
                        Image(uiImage: UIImage(named: "Fasong") ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 30)
                    }
                }
                .padding(10)
                .background(.black.opacity(0.1))
                Spacer()
            }
        }
    }
}

func detectDrag(end: CGPoint, start: CGPoint) -> DragGestureType {
    let horizontalMovement = end.x - start.x
    let verticalMovement = end.y - start.y
    
    if abs(horizontalMovement) > abs(verticalMovement) {
        if horizontalMovement > 0 {
            return .LeftToRight
        } else {
            return .RightToLeft
        }
    } else {
        if verticalMovement > 0 {
            return .TopToBottom
        } else {
            return .BottomToTop
        }
    }
}

enum DragGestureType {
    case None
    case LeftToRight
    case RightToLeft
    case TopToBottom
    case BottomToTop
}

#Preview {
    ChatView()
        .environmentObject(ChatViewModel(network: Network()))
}
