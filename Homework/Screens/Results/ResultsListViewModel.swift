//
//  ResultsListViewModel.swift
//  Homework
//
//  Created by Vlad Eliseev on 21.04.2024.
//

import Foundation
import Combine

final class ResultsListViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var selectedListSortType: SortType = .asc
    @Published var displayedSuffixesList: [(String, Int)] = []
    
    private let suffixesDict: [String: Int]
    
    private var cancellables = Set<AnyCancellable>()
    
    init(input: String) {
        let words = input.lowercased().components(separatedBy: " ")
        let suffixes = words.map { SuffixArray(str: $0) }
        
        var suffixesDict = [String: Int]()
        for suffixArr in suffixes {
            for suffix in suffixArr {
                suffixesDict[suffix.suff] = (suffixesDict[suffix.suff] ?? 0) + 1
            }
        }
        self.suffixesDict = suffixesDict
        
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        let searchPublisher = $searchText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
        
        Publishers.CombineLatest(searchPublisher, $selectedListSortType)
            .receive(on: DispatchQueue.global())
            .compactMap { [weak self] searchQuery, sortType -> [(String, Int)]? in
                guard let self else { return nil }
                return self.prepareSuffixesToDisplay(searchQuery: searchQuery, sortType: sortType)
            }
            .receive(on: DispatchQueue.main)
            .sink { suffixesToDisplay in
                self.displayedSuffixesList = suffixesToDisplay
            }
            .store(in: &cancellables)
    }
    
    private func prepareSuffixesToDisplay(searchQuery: String, sortType: SortType) -> [(String, Int)] {
        let filteredSuffixes: [String: Int]
        if !searchQuery.isEmpty {
            filteredSuffixes = self.suffixesDict.filter { $0.key.contains(searchQuery) }
        } else {
            filteredSuffixes = self.suffixesDict
        }
        return filteredSuffixes.sorted(by: {
            switch sortType {
            case .asc:
                return $0.key < $1.key
            case .desc:
                return $0.key > $1.key
            }
        }).map { ($0.key, $0.value) }
    }
}
