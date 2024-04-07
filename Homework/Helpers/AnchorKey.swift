//
//  AnchorKey.swift
//  Homework
//
//  Created by Vlad Eliseev on 07.04.2024.
//

import SwiftUI

struct AnchorKey: PreferenceKey {
    
    typealias Value = Anchor<CGPoint>?
    static var defaultValue: Value { nil }
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
