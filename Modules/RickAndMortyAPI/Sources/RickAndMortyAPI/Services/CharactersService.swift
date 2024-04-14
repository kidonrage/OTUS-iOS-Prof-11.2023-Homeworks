//
//  CharactersService.swift
//  Homework
//
//  Created by Vlad Eliseev on 14.04.2024.
//

import Combine

public final class CharactersService {
    
    private let api = RickAndMortyAPIImp()
    
    public init() {}
    
    public func fetchCharacters(page: Int) -> AnyPublisher<[Character], Never> {
        return Future<[Character], Never>.init { [weak self] promise in
            self?.api.getCharacters(page: page) { characters in
                promise(.success(characters))
            }
        }.eraseToAnyPublisher()
    }
}
