//
//  Flix.swift
//  Homework
//
//  Created by Vlad Eliseev on 14.04.2024.
//

import Foundation
import Combine
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
    case initialFetch
    case fetchNextPage
    
    // State mutating actions
    case setNextPage(Int)
    case setIsLoading(Bool)
    case setCharacters([Character])
}

// MARK: - Reducer

// Reducer должен быть ЧИСТОЙ ФУНКЦИЕЙ, к-рая принимает на вход актуальное состояние и action, и в зависимости от action'а меняет это состояние
//typealias Reducer<StateType, ActionType> = (inout StateType, ActionType) -> StateType

protocol Reducer {
    
    associatedtype StateType
    associatedtype ActionType
    
    func reduce(state: StateType, action: ActionType) -> StateType
}

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
        case .initialFetch:
            break
        case .fetchNextPage:
            break
        }
        return state
    }
}

// MARK: - Middleware

typealias Middleware<StateType, ActionType> = (StateType, ActionType) -> AnyPublisher<ActionType, Never>?

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
        case .initialFetch:
            break
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

final class CharactersStore: ObservableObject {
    
    // Доступ к состоянию извне read-only
    @Published private(set) var state: CharactersState = .init()
    
    private var tasks = [AnyCancellable]()
    
    private let serialQueue = DispatchQueue(label: "flux.serial.queue")
    
    private let reducer = CharactersReducer()
    private let middlewares: [Middleware<CharactersState, CharactersAction>]
    private var middlewareCancellables = Set<AnyCancellable>()
    
    init(
        initialState: CharactersState,
        middlewares: [Middleware<CharactersState, CharactersAction>]
    ) {
        self.state = initialState
        self.middlewares = middlewares
    }
    
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
