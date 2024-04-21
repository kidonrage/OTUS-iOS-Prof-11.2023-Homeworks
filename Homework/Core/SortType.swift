//
//  SortType.swift
//  Homework
//
//  Created by Vlad Eliseev on 21.04.2024.
//

import Foundation

enum SortType: CaseIterable, Hashable, Identifiable {
    
    var id: Int {
        hashValue
    }
    
    case asc
    case desc
    
    var title: String {
        switch self {
        case .asc:
            return "Asc"
        case .desc:
            return "Desc"
        }
    }
}
