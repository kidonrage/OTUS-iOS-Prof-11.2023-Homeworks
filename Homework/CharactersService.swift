//
//  CharactersService.swift
//  Homework
//
//  Created by Vlad Eliseev on 14.04.2024.
//

import RickAndMortyAPI
import Combine

final class CharactersService {
    
    // TODO: DI
    private let api = RickAndMortyAPIImp()
    
    func fetchCharacters(page: Int) -> AnyPublisher<[Character], Never> {
        return Future<[Character], Never>.init { [weak self] promise in
            self?.api.getCharacters(page: page) { characters in
                promise(.success(characters))
            }
        }.eraseToAnyPublisher()
    }
}
