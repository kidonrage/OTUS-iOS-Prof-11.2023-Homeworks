//
//  Screen.swift
//  Homework
//
//  Created by Vlad Eliseev on 02.04.2024.
//

import Foundation

struct HistoryEntry: Hashable, Equatable, Identifiable {
    
    var id: Int {
        hashValue
    }
    
    let suffixTitle: String
    let searchTime: TimeInterval
}

enum Screen: Identifiable, Hashable {
    
    var id: Int {
        return hashValue
    }
    
    case results(input: String)
    case history(history: [HistoryEntry])
}
