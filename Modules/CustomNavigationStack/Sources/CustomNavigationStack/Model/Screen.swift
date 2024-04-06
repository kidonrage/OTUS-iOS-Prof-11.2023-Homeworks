//
//  File.swift
//  
//
//  Created by Vlad Eliseev on 03.04.2024.
//

import Foundation
import SwiftUI

public struct Screen: Equatable {
    
    let id: String
    let view: AnyView
    
    public static func == (lhs: Screen, rhs: Screen) -> Bool {
        return lhs.id == rhs.id
    }
}
