//
//  LocationDetailsScreen.swift
//  Homework
//
//  Created by Vlad Eliseev on 07.04.2024.
//

import SwiftUI
import CustomNavigationStack

struct LocationDetailsScreen: View {
    
    @EnvironmentObject private var navigationVM: NavigationViewModel
    @ObservedObject private var store: LocationDetailsStore
    
    init(
        store: LocationDetailsStore
    ) {
        self.store = store
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            Spacer()
            Text(store.state.location?.name ?? "")
                .font(.title)
                .fontWeight(.bold)
            property(title: "Type", value: store.state.location?.type ?? "")
            property(title: "Dimension", value: store.state.location?.dimension ?? "")
            Button(action: {
                navigationVM.pop()
            }, label: {
                Image(systemName: "chevron.left")
                Text("Go back")
            })
            Spacer()
        })
        .padding(.horizontal, 16)
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .onAppear(perform: {
            store.dispatch(action: .loadLocation)
        })
    }
    
    @ViewBuilder
    func property(title: String, value: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption2)
            Text(value)
                .font(.title2)
        }
    }
}
