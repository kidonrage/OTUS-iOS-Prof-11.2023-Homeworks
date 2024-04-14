//
//  Tab.swift
//  Homework
//
//  Created by Vlad Eliseev on 14.04.2024.
//

import Foundation

enum Tab: CaseIterable {
    
    case characters
    case locations
    case episodes
    
    var title: String {
        switch self {
        case .characters:
            return "Characters"
        case .locations:
            return "Locations"
        case .episodes:
            return "Episodes"
        }
    }
}
