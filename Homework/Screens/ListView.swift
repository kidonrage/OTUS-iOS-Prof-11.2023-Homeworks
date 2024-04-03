//
//  ListView.swift
//  Homework
//
//  Created by Vlad Eliseev on 02.04.2024.
//

import Foundation
import SwiftUI

struct ListView: View {
    
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var router: ListRouter
    
    var body: some View {
        NavigationView(content: {
            List {
                NavigationLink(destination: ProfileView(), isActive: $router.isProfileOpened) { Text("Profile") }
                NavigationLink(destination: Text("Dashboard"), isActive: $router.isDashboardOpened) { Text("Dashboard") }
            }
        })
    }
}

#Preview {
    
    ListView()
}
