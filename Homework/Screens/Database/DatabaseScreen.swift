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
    
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    
    @State var selectedTabIndex = 0
    var tabs = Tab.allCases
    
    @ObservedObject var viewModel = DatabaseViewModel()
    
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
        List(viewModel.characters, id: \.id) { character in
            Button(
                action: {
                    navigationViewModel.push(
                        screenView: CharacterDetailsScreen(
                            character: character
                        )
                    )
                },
                label: {
                    HStack(alignment: .center, spacing: 14) {
                        AsyncImage(
                            url: URL(string: character.image),
                            content: { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                            },
                            placeholder: {
                                ProgressView()
                            }
                        )
                        .frame(width: 150, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Text(character.name)
                    }
                    .onAppear(perform: {
                        if viewModel.characters[viewModel.characters.count - 1].id == character.id {
                            // perform loading
                            viewModel.loadNextCharactersPage()
                        }
                    })
                }
            )
        }
        .onAppear(perform: {
            viewModel.loadNextCharactersPage()
        })
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
