//
//  ResultsScreen.swift
//  Homework
//
//  Created by Vlad Eliseev on 02.04.2024.
//

import SwiftUI
import Combine

struct ResultsScreen: View {
    
    @EnvironmentObject var appRouter: AppRouter
    @ObservedObject var listViewModel: ResultsListViewModel
    @ObservedObject var topViewModel: ResultsTopViewModel
    
    @State var selectedTab: ContentType = .list
    
    init(input: String) {
        self.listViewModel = ResultsListViewModel(input: input)
        self.topViewModel = ResultsTopViewModel(input: input)
    }
    
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
                HStack {
                    TextField(text: $listViewModel.searchText, label: {
                        Text("Поиск")
                    }).padding()
                    Button {
                        appRouter.path.append(.history(history: listViewModel.searchHistory))
                    } label: {
                        Image(systemName: "clock.fill")
                        Text(String(describing: listViewModel.searchHistory.count))
                    }

                    Picker(selection: $listViewModel.selectedListSortType) {
                        ForEach(SortType.allCases) { sortType in
                            Text(sortType.title).tag(sortType)
                        }
                    } label: {}
                }
                List($listViewModel.displayedSuffixesList, id: \.0) {
                    Text($0.wrappedValue.0 + " – " + String(describing: $0.wrappedValue.1))
                }
            case .top:
                Picker(selection: $topViewModel.selectedSortType) {
                    ForEach(SortType.allCases) { sortType in
                        Text(sortType.title).tag(sortType)
                    }
                } label: {}
                List($topViewModel.displayedSuffixesTop, id: \.0) {
                    Text($0.wrappedValue.0 + " – " + String(describing: $0.wrappedValue.1))
                }
            }
        }
        .navigationTitle("Результаты")
    }
}

#Preview {
    ResultsScreen(input: "banana")
}
