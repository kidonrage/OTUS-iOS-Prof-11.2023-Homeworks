//
//  DatabaseViewModel.swift
//  Homework
//
//  Created by Vlad Eliseev on 07.04.2024.
//

import Foundation
import RickAndMortyAPI

final class DatabaseViewModel: ObservableObject {
    
    private var charactersPageToLoad: Int = 0
    private var isCharactersLoading = false
    @Published var characters = [Character]()
    
    func loadNextCharactersPage() {
        guard !isCharactersLoading else { return }
        isCharactersLoading = true
        RickAndMortyAPI.shared.getCharacters(page: charactersPageToLoad) { [weak self] characters in
            self?.characters.append(contentsOf: characters)
            self?.charactersPageToLoad += 1
            self?.isCharactersLoading = false
        }
    }
}
