//
//  ResultsTopViewModel.swift
//  Homework
//
//  Created by Vlad Eliseev on 21.04.2024.
//

import Foundation
import Combine

final class ResultsTopViewModel: ObservableObject {
    
    @Published var selectedSortType: SortType = .desc
    @Published var displayedSuffixesTop: [(String, Int)] = []
    
    private let suffixesDict: [String: Int]
    
    private var cancellables = Set<AnyCancellable>()
    
    init(input: String) {
        let words = input.lowercased().components(separatedBy: " ")
        let suffixes = words.map { SuffixArray(str: $0) }
        
        var suffixesDict = [String: Int]()
        for suffixArr in suffixes {
            for suffix in suffixArr {
                guard suffix.suff.count == 3 else { continue } // По заданию оставляем только суффиксы длины 3
                suffixesDict[suffix.suff] = (suffixesDict[suffix.suff] ?? 0) + 1
            }
        }
        self.suffixesDict = suffixesDict
        
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        $selectedSortType
            .receive(on: DispatchQueue.global())
            .compactMap { [weak self] sortType -> [(String, Int)]? in
                guard let self else { return nil }
                return self.prepareSuffixesToDisplay(sortType: sortType)
            }
            .receive(on: DispatchQueue.main)
            .sink { suffixesToDisplay in
                self.displayedSuffixesTop = suffixesToDisplay
            }
            .store(in: &cancellables)
    }
    
    private func prepareSuffixesToDisplay(sortType: SortType) -> [(String, Int)] {
        return suffixesDict
            .sorted(by: {
                switch sortType {
                case .asc:
                    return $0.value < $1.value
                case .desc:
                    return $0.value > $1.value
                }
            })
            .map { ($0.key, $0.value) }
    }
}
