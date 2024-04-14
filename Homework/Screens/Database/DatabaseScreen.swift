//
//  DatabaseScreen.swift
//  Homework
//
//  Created by Vlad Eliseev on 02.04.2024.
//

import SwiftUI
import CustomNavigationStack
import RickAndMortyUI

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
    
    @EnvironmentObject private var navigationViewModel: NavigationViewModel
    
    @State private var selectedTabIndex = 0
    private var tabs = Tab.allCases
    
    @State private var favoriteEpisodes = [(index: Int, anchor: Anchor<CGPoint>)]()
    
    @ObservedObject private var viewModel = DatabaseViewModel()
    
    // TODO: DI
    @ObservedObject private var charactersStore = CharactersStore(
        initialState: .init(),
        middlewares: [charactersMiddleware(charactersService: CharactersService())]
    )
    
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
        List(charactersStore.state.characters.enumerated().map({ $0 }), id: \.element.id) { index, character in
            VStack {
                Button(
                    action: {
                        navigationViewModel.push(
                            screenView: CharacterDetailsScreen(
                                character: character
                            )
                        )
                    },
                    label: {
                        CharactersListItemView(character: character)
                        .onAppear(perform: {
                            if charactersStore.state.characters.count - 1 == index {
                                charactersStore.dispatch(action: .fetchNextPage)
                            }
                        })
                    }
                )
                if charactersStore.state.characters.count - 1 == index, charactersStore.state.isCharactersLoading {
                    ProgressView()
                        .scaleEffect(2.0, anchor: .center)
                        .padding(.vertical, 16)
                }
            }
        }
        .onAppear(perform: {
            if charactersStore.state.characters.isEmpty {
                charactersStore.dispatch(action: .fetchNextPage)
            }
        })
    }
    
    var locationsList: some View {
        List(viewModel.locations.enumerated().map({ $0 }), id: \.element.id) { index, location in
            VStack(alignment: .leading) {
                Text(location.name)
                Text(location.dimension)
                    .font(.caption)
                if viewModel.needToDisplayActivityInLocation(onIndex: index) {
                    HStack {
                        Spacer()
                        ProgressView()
                            .scaleEffect(2.0, anchor: .center)
                            .padding(.vertical, 16)
                        Spacer()
                    }
                }
            }
            .onAppear(perform: {
                viewModel.loadNextLocationsPageIfNeeded(appearedLocationIndex: index)
            })
        }
        .onAppear(perform: {
            viewModel.loadInitialLocationsIfNeeded()
        })
    }
    
    var episodesList: some View {
        ZStack(alignment: .bottom) {
            List(viewModel.episodes.enumerated().map({ $0 }), id: \.element.id) { index, episode in
                VStack(alignment: .leading) {
                    EpisodeView(name: episode.name, code: episode.episode)
                    if viewModel.needToDisplayActivityInEpisode(onIndex: index) {
                        HStack {
                            Spacer()
                            ProgressView()
                                .scaleEffect(2.0, anchor: .center)
                                .padding(.vertical, 16)
                            Spacer()
                        }
                    }
                }
                .anchorPreference(key: AnchorKey.self, value: .topLeading, transform: { $0 })
                .overlayPreferenceValue(AnchorKey.self, { anchor in
                    Button(
                        action: {
                            withAnimation(.easeIn) {
                                favoriteEpisodes.append((index: index, anchor: anchor!))
                            }
                        },
                        label: { }
                    )
                })
                .onAppear(perform: {
                    viewModel.loadNextEpisodesPageIfNeeded(appearedEpisodeIndex: index)
                })
            }
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray)
                .frame(height: 80)
                .overlay(Text("\(favoriteEpisodes.count)"))
                .background(
                    GeometryReader { proxy in
                        ZStack {
                            ForEach(Array(self.favoriteEpisodes.enumerated()), id: \.offset) { (_, item) in
                                let episode = viewModel.episodes[item.index]
                                EpisodeView(name: episode.name, code: episode.episode)
                                    .transition(.offset(x: proxy[item.anchor].x, y: proxy[item.anchor].y))
                            }
                        }
                    }
                )
                .offset(y: 80)
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear(perform: {
            viewModel.loadInitialEpisodesIfNeeded()
        })
    }
    
    struct EpisodeView: View {
        
        let name: String
        let code: String
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(name)
                    Text(code)
                        .font(.caption)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    DatabaseScreen()
}
