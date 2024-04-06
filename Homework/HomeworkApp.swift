//
//  HomeworkApp.swift
//  Homework
//
//  Created by Vlad Eliseev on 02.04.2024.
//

import SwiftUI
import CustomNavigationStack

@main
struct HomeworkApp: App {
    
    private let viewModel = NavigationViewModel()
    
    var body: some Scene {
        WindowGroup {
            CustomNavigationView(viewModel: viewModel, contentBuilder: {
                DatabaseScreen()
            }, transition: (push: .scale, pop: .slide))
        }
    }
}
