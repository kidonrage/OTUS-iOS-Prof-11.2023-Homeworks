//
//  ResultsContentType.swift
//  Homework
//
//  Created by Vlad Eliseev on 21.04.2024.
//

import Foundation

enum ContentType: CaseIterable, Hashable, Identifiable {
    
    var id: Int {
        return hashValue
    }
    
    case list
    case top
    
    var title: String {
        switch self {
        case .list:
            return "Список"
        case .top:
            return "ТОП-10"
        }
    }
}
