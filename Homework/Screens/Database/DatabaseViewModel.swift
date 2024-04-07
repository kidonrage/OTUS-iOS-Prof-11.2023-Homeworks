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
    
    private var locationsPageToLoad: Int = 0
    private var isLocationsLoading = false
    @Published var locations = [Location]()
    
    // MARK: - Public methods
    
    // MARK: Characters
    
    func loadInitialCharactersIfNeeded() {
        guard characters.isEmpty else { return }
        loadNextCharactersPage()
    }
    
    func loadNextCharactersPageIfNeeded(appearedCharacterIndex index: Int) {
        print(index)
        guard characters[characters.count - 1].id == characters[index].id else { return }
        loadNextCharactersPage()
    }
    
    // MARK: Locations
    
    func loadInitialLocationsIfNeeded() {
        guard locations.isEmpty else { return }
        loadNextLocationsPage()
    }
    
    func loadNextLocationsPageIfNeeded(appearedLocationIndex index: Int) {
        print(index)
        guard locations[locations.count - 1].id == locations[index].id else { return }
        loadNextLocationsPage()
    }
    
    // MARK: - Private methods
    
    private func loadNextCharactersPage() {
        guard !isCharactersLoading else { return }
        isCharactersLoading = true
        RickAndMortyAPI.shared.getCharacters(page: charactersPageToLoad) { [weak self] characters in
            self?.characters.append(contentsOf: characters)
            self?.charactersPageToLoad += 1
            self?.isCharactersLoading = false
        }
    }
    
    private func loadNextLocationsPage() {
        guard !isLocationsLoading else { return }
        isLocationsLoading = true
        RickAndMortyAPI.shared.loadLocations(page: charactersPageToLoad) { [weak self] response in
            self?.locations.append(contentsOf: response?.results ?? [])
            self?.locationsPageToLoad += 1
            self?.isLocationsLoading = false
        }
    }
}
