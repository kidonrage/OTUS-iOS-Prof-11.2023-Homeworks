//
//  HomeworkApp.swift
//  Homework
//
//  Created by Vlad Eliseev on 02.04.2024.
//

import SwiftUI
import CustomNavigationStack
import RickAndMortyAPI

@main
struct HomeworkApp: App {
    
    private let viewModel = NavigationViewModel()
    
    init() {
        let api: RickAndMortyAPI = RickAndMortyAPIImp()
        ServiceLocator.shared.register(service: api)
    }
    
    var body: some Scene {
        WindowGroup {
            CustomNavigationView(viewModel: viewModel, contentBuilder: {
                DatabaseScreen(
                    charactersStore: CharactersStore(
                        initialState: .init(),
                        middlewares: [charactersMiddleware(charactersService: CharactersService())]
                    ),
                    locationsStore: LocationsStore(
                        initialState: .init(),
                        middlewares: [locationsMiddleware(locationsService: LocationsService())]
                    ),
                    episodesStore: EpisodesStore(
                        initialState: .init(),
                        middlewares: [episodesMiddleware(episodesService: EpisodesService())]
                    )
                )
            }, transition: (push: .scale, pop: .slide))
        }
    }
}
