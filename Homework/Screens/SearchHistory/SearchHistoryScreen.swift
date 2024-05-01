//
//  SearchHistoryScreen.swift
//  Homework
//
//  Created by Vlad Eliseev on 30.04.2024.
//

import SwiftUI

struct SearchHistoryScreen: View {
    
    private let list: [HistoryEntry]
    private let max: HistoryEntry?
    private let min: HistoryEntry?
    
    init(list: [HistoryEntry]) {
        self.list = list
        self.max = list.max(by: { $0.searchTime > $1.searchTime })
        self.min = list.min(by: { $0.searchTime > $1.searchTime })
    }
    
    var body: some View {
        List(list.reversed()) { entry in
            HStack {
                Text(entry.suffixTitle)
                Spacer()
                Text(String(format: "%02d", entry.searchTime) + "s")
            }
            .background(entry == max ? .red : entry == min ? .green : .white)
        }
    }
}
