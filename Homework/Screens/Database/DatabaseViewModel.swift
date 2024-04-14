//
//  DatabaseViewModel.swift
//  Homework
//
//  Created by Vlad Eliseev on 07.04.2024.
//

import Foundation
import RickAndMortyAPI

final class DatabaseViewModel: ObservableObject {
    
    @ForceInjected private var api: RickAndMortyAPI

    private var locationsPageToLoad: Int = 1
    @Published private(set) var isLocationsLoading = false
    @Published var locations = [Location]()
    
    private var episodesPageToLoad: Int = 1
    @Published private(set) var isEpisodesLoading = false
    @Published var episodes = [Episode]()
    
    // MARK: - Public methods
    
    // MARK: Locations
    
    func loadInitialLocationsIfNeeded() {
        guard locations.isEmpty else { return }
        loadNextLocationsPage()
    }
    
    func loadNextLocationsPageIfNeeded(appearedLocationIndex index: Int) {
        guard locations[locations.count - 1].id == locations[index].id else { return }
        loadNextLocationsPage()
    }
    
    func needToDisplayActivityInLocation(onIndex index: Int) -> Bool {
        return locations.count - 1 == index && isLocationsLoading
    }
    
    // MARK: Episodes
    
    func loadInitialEpisodesIfNeeded() {
        guard episodes.isEmpty else { return }
        loadNextEpisodesPage()
    }
    
    func loadNextEpisodesPageIfNeeded(appearedEpisodeIndex index: Int) {
        guard episodes[episodes.count - 1].id == episodes[index].id else { return }
        loadNextEpisodesPage()
    }
    
    func needToDisplayActivityInEpisode(onIndex index: Int) -> Bool {
        return episodes.count - 1 == index && isEpisodesLoading
    }
    
    // MARK: - Private methods
    
    private func loadNextLocationsPage() {
        guard !isLocationsLoading else { return }
        isLocationsLoading = true
        api.loadLocations(page: locationsPageToLoad) { [weak self] response in
            self?.locations.append(contentsOf: response?.results ?? [])
            self?.locationsPageToLoad += 1
            self?.isLocationsLoading = false
        }
    }
    
    private func loadNextEpisodesPage() {
        guard !isEpisodesLoading else { return }
        isEpisodesLoading = true
        api.loadEpisodes(page: episodesPageToLoad) { [weak self] response in
            self?.episodes.append(contentsOf: response?.results ?? [])
            self?.episodesPageToLoad += 1
            self?.isEpisodesLoading = false
        }
    }

}
