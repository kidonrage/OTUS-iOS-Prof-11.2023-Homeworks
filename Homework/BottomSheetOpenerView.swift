//
//  BottomSheetOpenerView.swift
//  Homework
//
//  Created by Vlad Eliseev on 02.04.2024.
//

import Foundation
import SwiftUI

struct BottomSheetOpenerView: View {
    
    @State var isBottomSheetOpened = false
    
    var body: some View {
        Button {
            isBottomSheetOpened = true
        } label: {
            Text("Открой меня!")
        }.sheet(
            isPresented: $isBottomSheetOpened,
            content: {
                Text("Бу!")
            }
        )
    }
}
