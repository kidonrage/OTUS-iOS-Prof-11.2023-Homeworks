//
//  Screen.swift
//  Homework
//
//  Created by Vlad Eliseev on 02.04.2024.
//

import Foundation

enum Screen: Identifiable, Hashable {
    
    var id: Int {
        return hashValue
    }
    
    case results(input: String)
}
