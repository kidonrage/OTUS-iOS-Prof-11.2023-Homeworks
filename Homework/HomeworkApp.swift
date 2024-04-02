//
//  HomeworkApp.swift
//  Homework
//
//  Created by Vlad Eliseev on 02.04.2024.
//

import SwiftUI

@main
struct HomeworkApp: App {
    
    @StateObject var appRouter = AppRouter()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appRouter)
        }
    }
}
