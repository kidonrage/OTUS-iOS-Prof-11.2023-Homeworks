//
//  ContentView.swift
//  Homework
//
//  Created by Vlad Eliseev on 02.04.2024.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appRouter: AppRouter
    
    @StateObject var listRouter = ListRouter()
    
    var body: some View {
        TabView(selection: $appRouter.focusedTab) {
            AnotherTabOpenerView()
                .tag(Tab.anotherTabOpener)
                .tabItem {
                    Label("Ссылка", systemImage: "link")
                }
                .environmentObject(listRouter)
            
            ListView()
                .tag(Tab.list)
                .tabItem {
                    Label("Список", systemImage: "list.bullet")
                }
                .environmentObject(listRouter)
            
            BottomSheetOpenerView()
                .tag(Tab.bottomSheet)
                .tabItem {
                    Label("Торчун", systemImage: "lanyardcard")
                }
            
            NewsScreen()
                .tag(Tab.news)
                .tabItem {
                    Label("Новости", systemImage: "newspaper")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppRouter())
}
