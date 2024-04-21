//
//  HomeworkApp.swift
//  Homework
//
//  Created by Vlad Eliseev on 02.04.2024.
//

import SwiftUI

@main
struct HomeworkApp: App {
    
    @ObservedObject var appRouter = AppRouter()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appRouter.path) {
                InputView()
                    .navigationDestination(for: Screen.self) { selection in
                        switch selection {
                        case .results(let input):
                            ResultsScreen()
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
            }
            .environmentObject(appRouter)
        }
    }
    
    init() {
        print(buildSuffixArray("banana"))
    }
}
