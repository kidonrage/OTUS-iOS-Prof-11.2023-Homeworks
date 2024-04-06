//
//  DatabaseScreen.swift
//  Homework
//
//  Created by Vlad Eliseev on 02.04.2024.
//

import SwiftUI
import CustomNavigationStack

enum Tab: CaseIterable {
    
    case characters
    case locations
    case episodes
    
    var title: String {
        switch self {
        case .characters:
            return "Characters"
        case .locations:
            return "Locations"
        case .episodes:
            return "Episodes"
        }
    }
}

struct DatabaseScreen: View {
    
    @EnvironmentObject var viewModel: NavigationViewModel
    
    @State var selectedTabIndex = 0
    var tabs = Tab.allCases
    
    var body: some View {
        VStack {
            Text("Rick and morty database")
                .font(.headline)
            Picker("Please choose content type", selection: $selectedTabIndex) {
                ForEach(0..<tabs.count, id: \.hashValue) { tabIndex in
                    Text(tabs[tabIndex].title).tag(tabIndex)
                }
            }
            .pickerStyle(.segmented)
            switch tabs[selectedTabIndex] {
            case .characters:
                charactersList
            case .locations:
                locationsList
            case .episodes:
                episodesList
            }
        }
    }
    
    var charactersList: some View {
        List(0..<10) { item in
            Button(action: {
                viewModel.push(screenView: DetailsScreen())
            }, label: {
                Text("Character " + String(item))
            })
        }
    }
    
    var locationsList: some View {
        List(0..<10) { item in
            Text("Location " + String(item))
        }
    }
    
    var episodesList: some View {
        List(0..<10) { item in
            Text("Episode " + String(item))
        }
    }
}

#Preview {
    DatabaseScreen()
}
