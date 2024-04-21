//
//  SuffixArray.swift
//  Homework
//
//  Created by Vlad Eliseev on 20.04.2024.
//

import Foundation

// Naive algorithm for building suffix array of a given text
                        
struct Suffix: Hashable, Comparable, CustomStringConvertible {
    
    var description: String {
        return "(\(index),\(suff))"
    }
    
    let index: Int
    let suff: String
    
    // A comparison function used by sort() to compare two suffixes
    static func < (lhs: Suffix, rhs: Suffix) -> Bool {
        return lhs.suff < rhs.suff
    }
}

// This is the main function that takes a string 'str' of size n as an
// argument, builds and return the suffix array for the given string
//func buildSuffixArray(_ str: String) -> [Int] {
//    // A structure to store suffixes and their indexes
//    let suffixes: [Suffix] = str.enumerated().map { i, char in
//        return Suffix(index: i, suff: String(str.suffix(str.count - i)))
//    }
//    print(suffixes)
//    // Sort the suffixes using the comparison function defined above.
//    let sorted = suffixes.sorted()
//    print(sorted)
//    // Store indexes of all sorted suffixes in the suffix array. Return the suffix array
//    return sorted.map { $0.index }
//}

struct SuffixArray: CustomStringConvertible, Hashable, Identifiable, Sequence {
    
    var description: String {
        return "[" + suffixes.map { $0.description }.joined(separator: ", ") + "]"
    }
    
    
    var id: Int {
        return hashValue
    }
    
    private let suffixes: [Suffix]
    
    init(str: String) {
        // A structure to store suffixes and their indexes
        let suffixes: [Suffix] = str.enumerated().map { i, char in
            return Suffix(index: i, suff: String(str.suffix(str.count - i)))
        }
        print(suffixes)
        // Sort the suffixes using the comparison function defined above.
        let sorted = suffixes.sorted()
        print(sorted)
        // Store indexes of all sorted suffixes in the suffix array. Return the suffix array
        self.suffixes = suffixes
    }
    
    func makeIterator() -> IndexingIterator<[Suffix]> {
        return suffixes.makeIterator()
    }
}
