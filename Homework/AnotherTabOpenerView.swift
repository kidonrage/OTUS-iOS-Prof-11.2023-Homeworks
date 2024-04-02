//
//  AnotherTabOpenerView.swift
//  Homework
//
//  Created by Vlad Eliseev on 02.04.2024.
//

import Foundation
import SwiftUI

struct AnotherTabOpenerView: View {
    
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var listRouter: ListRouter
    
    var body: some View {
        VStack(content: {
            Button {
                appRouter.focusedTab = .list
                listRouter.isProfileOpened = true
            } label: {
                Text("Нажми на меня и откроется профиль!")
            }
            Button {
                appRouter.focusedTab = .list
                listRouter.isDashboardOpened = true
            } label: {
                Text("Нажми на меня и откроется дэшборд!")
            }
        })
    }
}
