//
//  File.swift
//  
//
//  Created by Vlad Eliseev on 03.04.2024.
//

import Foundation
import SwiftUI

public enum NavigationType {
    
    case push
    case pop
    case popToRoot
}

public enum TransitionType {
    
    case none
    case custom(AnyTransition)
}
