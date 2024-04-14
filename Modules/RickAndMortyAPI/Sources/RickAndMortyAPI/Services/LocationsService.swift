//
//  LocationsService.swift
//  Homework
//
//  Created by Vlad Eliseev on 14.04.2024.
//

import Foundation
import Combine

public final class LocationsService {
    
    private let api = RickAndMortyAPIImp()
    
    public init() {}
    
    public func fetchLocations(page: Int) -> AnyPublisher<[Location], Never> {
        return Future<[Location], Never>.init { [weak self] promise in
            self?.api.loadLocations(page: page) { locations in
                promise(.success(locations?.results ?? []))
            }
        }.eraseToAnyPublisher()
    }
    
    public func fetchLocation(locationUrl: URL) -> AnyPublisher<Location?, Never> {
        return Future<Location?, Never>.init { [weak self] promise in
            self?.api.loadLocation(locationUrl: locationUrl, completionHandler: { location in
                promise(.success(location))
            })
        }.eraseToAnyPublisher()
    }
}
