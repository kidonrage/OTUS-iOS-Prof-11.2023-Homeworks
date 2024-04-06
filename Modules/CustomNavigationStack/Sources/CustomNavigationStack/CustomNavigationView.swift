//
//  SwiftUIView.swift
//  
//
//  Created by Vlad Eliseev on 03.04.2024.
//

import SwiftUI

public struct CustomNavigationView<Content: View>: View {
    
    @ObservedObject var viewModel: NavigationViewModel
    
    private let content: Content
    
    private let transition: (push: AnyTransition, pop: AnyTransition)
    
    public init(
        viewModel: NavigationViewModel,
        contentBuilder: @escaping () -> Content,
        transition: (push: AnyTransition, pop: AnyTransition)
    ) {
        self.viewModel = viewModel
        self.content = contentBuilder()
        self.transition = transition
    }
    
    public var body: some View {
        let isRoot = viewModel.currentScreen == nil
        ZStack {
            if isRoot {
                content
                    .environmentObject(viewModel)
                    .transition(viewModel.currentNavigationType == .push ? transition.push : transition.pop)
            } else {
                viewModel.currentScreen?.view
                    .environmentObject(viewModel)
                    .transition(viewModel.currentNavigationType == .push ? transition.push : transition.pop)
            }
        }
    }
}
