//
//  ResultsScreen.swift
//  Homework
//
//  Created by Vlad Eliseev on 02.04.2024.
//

import SwiftUI

enum ContentType: CaseIterable, Hashable, Identifiable {
    
    var id: Int {
        return hashValue
    }
    
    case list
    case top
    
    var title: String {
        switch self {
        case .list:
            return "Список"
        case .top:
            return "ТОП-10"
        }
    }
}

struct ResultsScreen: View {
    
    @EnvironmentObject var appRouter: AppRouter
    
    @State var selectedTab: ContentType = .list
    
    @State var searchText: String = ""
    
    var body: some View {
        VStack {
            Picker(selection: $selectedTab) {
                ForEach(ContentType.allCases) { tab in
                    Text(tab.title).tag(tab)
                }
            } label: {}
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            switch selectedTab {
            case .list:
                TextField(text: $searchText, label: {
                    Text("Поиск")
                }).padding()
                List([0, 1, 2], id: \.self) {
                    Text("\($0)")
                }
            case .top:
                List([0, 1, 2], id: \.self) {
                    Text("\($0)")
                }
            }
        }
        .navigationTitle("Результаты")
    }
}

#Preview {
    ResultsScreen()
}
