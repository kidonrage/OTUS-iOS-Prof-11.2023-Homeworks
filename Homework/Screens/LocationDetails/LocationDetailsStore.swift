//
//  LocationDetailsStore.swift
//  Homework
//
//  Created by Vlad Eliseev on 14.04.2024.
//

import Foundation
import Combine
import RickAndMortyAPI
import Flux

// MARK: - State

struct LocationDetailsState {
    
    let locationUrl: URL
    var location: Location?
}

// MARK: - Action

enum LocationDetailsAction {
    
    // UI-initiated action
    case loadLocation
    
    // state mutating action
    case setLocation(Location?)
}

// MARK: - Reducer

struct LocationDetailsReducer: Reducer {
    
    func reduce(state: LocationDetailsState, action: LocationDetailsAction) -> LocationDetailsState {
        var state = state
        switch action {
        case .loadLocation:
            break
        case .setLocation(let location):
            state.location = location
        }
        return state
    }
}

// MARK: - Middleware

func locationDetailsMiddleware(locationsService: LocationsService) -> Middleware<LocationDetailsState, LocationDetailsAction> {
    return { state, action in
        switch action {
        case .loadLocation:
            return locationsService.fetchLocation(locationUrl: state.locationUrl)
                .map { LocationDetailsAction.setLocation($0) }
                .eraseToAnyPublisher()
        case .setLocation:
            break
        }
        return Empty().eraseToAnyPublisher()
    }
}

// MARK: - Store

final class LocationDetailsStore: FluxStore<LocationDetailsState, LocationDetailsAction>, ObservableObject {
    
    private let serialQueue = DispatchQueue(label: "flux.locations")
    private let reducer = LocationDetailsReducer()

    func dispatch(action: LocationDetailsAction) {
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
