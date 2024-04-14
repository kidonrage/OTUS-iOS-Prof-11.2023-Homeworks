//
//  CharactersStore.swift
//  Homework
//
//  Created by Vlad Eliseev on 14.04.2024.
//

import Foundation
import Combine
import Flux
import RickAndMortyAPI

// MARK: - State

struct CharactersState {
    
    var charactersPageToLoad: Int = 1
    var isCharactersLoading = false
    var characters = [Character]()
}

// MARK: - Action

enum CharactersAction {
    
    // User-initiated actions
    case fetchNextPage
    
    // State mutating actions
    case setNextPage(Int)
    case setIsLoading(Bool)
    case setCharacters([Character])
}

// MARK: - Reducer

struct CharactersReducer: Reducer {
    
    func reduce(state: CharactersState, action: CharactersAction) -> CharactersState {
        var state = state
        switch action {
        case let .setNextPage(page):
            state.charactersPageToLoad = page
        case let .setIsLoading(isLoading):
            state.isCharactersLoading = isLoading
        case .setCharacters(let array):
            state.characters = array
        case .fetchNextPage:
            break
        }
        return state
    }
}

// MARK: - Middleware

func charactersMiddleware(charactersService: CharactersService) -> Middleware<CharactersState, CharactersAction> {
    return { state, action in
        switch action {
        case .fetchNextPage:
            guard !state.isCharactersLoading else { return Empty().eraseToAnyPublisher() }
            let load = charactersService.fetchCharacters(page: state.charactersPageToLoad)
                .map { CharactersAction.setCharacters(state.characters + $0) }
                .eraseToAnyPublisher()
            return Just(.setIsLoading(true))
                .append(load)
                .append(Just(CharactersAction.setNextPage(state.charactersPageToLoad + 1)))
                .append(Just(CharactersAction.setIsLoading(false)))
                .eraseToAnyPublisher()
        case .setNextPage(_):
            break
        case .setIsLoading(_):
            break
        case .setCharacters(_):
            break
        }
        return Empty().eraseToAnyPublisher()
    }
}

// MARK: - Store

final class CharactersStore: FluxStore<CharactersState, CharactersAction>, ObservableObject {

    private let serialQueue = DispatchQueue(label: "flux.characters")
    private let reducer = CharactersReducer()
    
    func dispatch(action: CharactersAction) {
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
