//
//  NavgationView.swift
//  AIAssistant
//
//  Created by  吴 熠 on 2023/10/24.
//

import SwiftUI

struct ChatNavView: View {
    @StateObject var chatVM = ChatViewModel(network: Network())
    @State var selectionTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectionTab) {
            ChatView()
                .tabItem {
                    Text("聊天")
                }
                .tag(0)
            
            ChatHistoryView()
                .tabItem {
                    Text("历史")
                }
                .tag(1)
        }
        .accentColor(.black)
        .environmentObject(chatVM)
    }
}

#Preview {
    ChatNavView()
}
