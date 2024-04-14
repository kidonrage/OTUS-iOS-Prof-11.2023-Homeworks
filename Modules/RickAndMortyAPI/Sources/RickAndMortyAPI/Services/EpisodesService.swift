//
//  EpisodesService.swift
//  Homework
//
//  Created by Vlad Eliseev on 14.04.2024.
//

import Combine

public final class EpisodesService {
    
    private let api = RickAndMortyAPIImp()
    
    public init() {}
    
    public func fetchEpisodes(page: Int) -> AnyPublisher<[Episode], Never> {
        return Future<[Episode], Never>.init { [weak self] promise in
            self?.api.loadEpisodes(page: page) { response in
                promise(.success(response?.results ?? []))
            }
        }.eraseToAnyPublisher()
    }
}
