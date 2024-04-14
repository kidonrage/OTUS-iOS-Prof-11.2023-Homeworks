//
//  EpisodesStore.swift
//  Homework
//
//  Created by Vlad Eliseev on 14.04.2024.
//

import Foundation
import Combine
import Flux
import RickAndMortyAPI

// MARK: - State

struct EpisodesState {
    
    var pageToLoad: Int = 1
    var isLoading = false
    var episodes = [Episode]()
}

// MARK: - Action

enum EpisodesAction {
    
    // User-initiated actions
    case fetchNextPage
    
    // State mutating actions
    case setNextPage(Int)
    case setIsLoading(Bool)
    case setEpisodes([Episode])
}

// MARK: - Reducer

struct EpisodesReducer: Reducer {
    
    func reduce(state: EpisodesState, action: EpisodesAction) -> EpisodesState {
        var state = state
        switch action {
        case let .setNextPage(page):
            state.pageToLoad = page
        case let .setIsLoading(isLoading):
            state.isLoading = isLoading
        case .setEpisodes(let array):
            state.episodes = array
        case .fetchNextPage:
            break
        }
        return state
    }
}

// MARK: - Middleware

func episodesMiddleware(episodesService: EpisodesService) -> Middleware<EpisodesState, EpisodesAction> {
    return { state, action in
        switch action {
        case .fetchNextPage:
            guard !state.isLoading else { return Empty().eraseToAnyPublisher() }
            let load = episodesService.fetchEpisodes(page: state.pageToLoad)
                .map { EpisodesAction.setEpisodes(state.episodes + $0) }
                .eraseToAnyPublisher()
            return Just(.setIsLoading(true))
                .append(load)
                .append(Just(EpisodesAction.setNextPage(state.pageToLoad + 1)))
                .append(Just(EpisodesAction.setIsLoading(false)))
                .eraseToAnyPublisher()
        case .setNextPage(_):
            break
        case .setIsLoading(_):
            break
        case .setEpisodes(_):
            break
        }
        return Empty().eraseToAnyPublisher()
    }
}

// MARK: - Store

final class EpisodesStore: FluxStore<EpisodesState, EpisodesAction>, ObservableObject {
    
    private let serialQueue = DispatchQueue(label: "flux.episodes")
    private let reducer = EpisodesReducer()

    func dispatch(action: EpisodesAction) {
        state = reducer.reduce(state: state, action: action)
        
        for middleware in middlewares {
            guard let middleware = middleware(state, action) else { continue }
            middleware
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: dispatch)
                .store(in: &middlewareCancellables)
        }
    }
}
