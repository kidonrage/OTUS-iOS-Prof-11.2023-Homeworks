//
//  Flix.swift
//  Homework
//
//  Created by Vlad Eliseev on 14.04.2024.
//

import Foundation
import Combine

// MARK: - Reducer

// Reducer должен быть ЧИСТОЙ ФУНКЦИЕЙ, к-рая принимает на вход актуальное состояние и action, и в зависимости от action'а меняет это состояние
//typealias Reducer<StateType, ActionType> = (inout StateType, ActionType) -> StateType

public protocol Reducer {
    
    associatedtype StateType
    associatedtype ActionType
    
    func reduce(state: StateType, action: ActionType) -> StateType
}

public typealias Middleware<StateType, ActionType> = (StateType, ActionType) -> AnyPublisher<ActionType, Never>?

// MARK: - Store

open class FluxStore<StateType, ActionType> {
    
    // Доступ к состоянию извне read-only
    @Published public var state: StateType
    
    public let middlewares: [Middleware<StateType, ActionType>]
    public var middlewareCancellables = Set<AnyCancellable>()
    
    public init(
        initialState: StateType,
        middlewares: [Middleware<StateType, ActionType>]
    ) {
        self.state = initialState
        self.middlewares = middlewares
    }
}
