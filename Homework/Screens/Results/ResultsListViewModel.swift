//
//  ResultsListViewModel.swift
//  Homework
//
//  Created by Vlad Eliseev on 21.04.2024.
//

import Foundation
import Combine

@MainActor
final class ResultsListViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var selectedListSortType: SortType = .asc
    @Published var displayedSuffixesList: [(String, Int)] = []
    @Published var searchHistory: [HistoryEntry] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    private let searchScheduler: SearchJobScheduler
    
    init(input: String) {
        let words = input.lowercased().components(separatedBy: " ")
        let suffixes = words.map { SuffixArray(str: $0) }
        
        var suffixesDict = [String: Int]()
        for suffixArr in suffixes {
            for suffix in suffixArr {
                suffixesDict[suffix.suff] = (suffixesDict[suffix.suff] ?? 0) + 1
            }
        }
        self.searchScheduler = SearchJobScheduler(suffixesDict: suffixesDict)
        
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        let searchPublisher = $searchText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
        
        Publishers.CombineLatest(searchPublisher, $selectedListSortType)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] searchQuery, sortType in
                guard let self else { return }
                Task {
                    let (suffixesList, searchEntry) = await self.searchScheduler.prepareSuffixesToDisplay(
                        searchQuery: searchQuery, sortType: sortType
                    )
                    self.displayedSuffixesList = suffixesList
                    self.searchHistory.append(searchEntry)
                }
            }
            .store(in: &cancellables)
    }
}

private actor SearchJobScheduler {
    
    private let suffixesDict: [String: Int]
    
    init(suffixesDict: [String : Int]) {
        self.suffixesDict = suffixesDict
    }
    
    func prepareSuffixesToDisplay(searchQuery: String, sortType: SortType) async -> ([(String, Int)], HistoryEntry) {
        let start = DispatchTime.now()
        let filteredSuffixes: [String: Int]
        if !searchQuery.isEmpty {
            filteredSuffixes = self.suffixesDict.filter { $0.key.contains(searchQuery) }
        } else {
            filteredSuffixes = self.suffixesDict
        }
        return (
            filteredSuffixes.sorted(by: {
                switch sortType {
                case .asc:
                    return $0.key < $1.key
                case .desc:
                    return $0.key > $1.key
                }
            }).map { ($0.key, $0.value) },
            .init(suffixTitle: searchQuery, searchTime: TimeInterval((DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000))
        )
    }
}
