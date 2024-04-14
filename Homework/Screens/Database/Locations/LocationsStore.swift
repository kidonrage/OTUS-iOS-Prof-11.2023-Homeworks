//
//  LocationsStore.swift
//  Homework
//
//  Created by Vlad Eliseev on 14.04.2024.
//

import Foundation
import Combine
import Flux
import RickAndMortyAPI

// MARK: - State

struct LocationsState {
    
    var pageToLoad: Int = 1
    var isLoading = false
    var locations = [Location]()
}

// MARK: - Action

enum LocationsAction {
    
    // User-initiated actions
    case fetchNextPage
    
    // State mutating actions
    case setNextPage(Int)
    case setIsLoading(Bool)
    case setLocations([Location])
}

// MARK: - Reducer

struct LocationsReducer: Reducer {
    
    func reduce(state: LocationsState, action: LocationsAction) -> LocationsState {
        var state = state
        switch action {
        case let .setNextPage(page):
            state.pageToLoad = page
        case let .setIsLoading(isLoading):
            state.isLoading = isLoading
        case .setLocations(let array):
            state.locations = array
        case .fetchNextPage:
            break
        }
        return state
    }
}

// MARK: - Middleware

func locationsMiddleware(locationsService: LocationsService) -> Middleware<LocationsState, LocationsAction> {
    return { state, action in
        switch action {
        case .fetchNextPage:
            guard !state.isLoading else { return Empty().eraseToAnyPublisher() }
            let load = locationsService.fetchLocations(page: state.pageToLoad)
                .map { LocationsAction.setLocations(state.locations + $0) }
                .eraseToAnyPublisher()
            return Just(.setIsLoading(true))
                .append(load)
                .append(Just(LocationsAction.setNextPage(state.pageToLoad + 1)))
                .append(Just(LocationsAction.setIsLoading(false)))
                .eraseToAnyPublisher()
        case .setNextPage(_):
            break
        case .setIsLoading(_):
            break
        case .setLocations(_):
            break
        }
        return Empty().eraseToAnyPublisher()
    }
}

// MARK: - Store

final class LocationsStore: FluxStore<LocationsState, LocationsAction>, ObservableObject {
    
    private let serialQueue = DispatchQueue(label: "flux.locations")
    private let reducer = LocationsReducer()

    func dispatch(action: LocationsAction) {
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
