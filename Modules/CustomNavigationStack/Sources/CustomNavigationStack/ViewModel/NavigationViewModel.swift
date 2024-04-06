//
//  File.swift
//  
//
//  Created by Vlad Eliseev on 03.04.2024.
//

import Foundation
import SwiftUI

public class NavigationViewModel: ObservableObject {
    
    @Published public var currentScreen: Screen?
    
    var currentNavigationType: NavigationType = .push
    
    var screenStack = NavigationStack() {
        didSet {
            self.currentScreen = screenStack.top()
        }
    }
    
    private let animation: Animation
    
    public init(animation: Animation = .easeIn) {
        self.animation = animation
    }
    
    public func push(screenView: any View) {
        withAnimation(animation) {
            currentNavigationType = .push
            screenStack.push(newScreen: Screen(id: UUID().uuidString, view: AnyView(screenView)))
        }
    }
    
    public func pop() {
        withAnimation(animation) {
            currentNavigationType = .pop
            screenStack.pop()
        }
    }
    
    public func popToRoot() {
        withAnimation(animation) {
            currentNavigationType = .popToRoot
            screenStack.popToRoot()
        }
    }
}
