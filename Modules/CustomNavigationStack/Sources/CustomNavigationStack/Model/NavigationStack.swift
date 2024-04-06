//
//  File.swift
//  
//
//  Created by Vlad Eliseev on 03.04.2024.
//

import Foundation

struct NavigationStack {
    
    private var screens: [Screen] = []
    
    func top() -> Screen? {
        return screens.last
    }
    
    mutating func push(newScreen: Screen) {
        screens.append(newScreen)
    }
    
    mutating func pop() {
        screens.removeLast()
    }
    
    mutating func popToRoot() {
        screens.removeAll()
    }
}
