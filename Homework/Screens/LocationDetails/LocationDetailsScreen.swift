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
    
    @ObservedObject private var viewModel: LocationDetailsViewModel
    
    init(viewModel: LocationDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            Spacer()
            Text(viewModel.model?.name ?? "")
                .font(.title)
                .fontWeight(.bold)
            VStack(alignment: .leading) {
                Text("Type")
                    .font(.caption2)
                Text(viewModel.model?.type ?? "")
                    .font(.title2)
            }
            VStack(alignment: .leading) {
                Text("Dimension")
                    .font(.caption2)
                Text(viewModel.model?.dimension ?? "")
                    .font(.title2)
            }
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
            viewModel.handleOnAppear()
        })
    }
}

#Preview {
    LocationDetailsScreen(
        viewModel: LocationDetailsViewModel(
            locationUrl: "https://rickandmortyapi.com/api/location/1"
        )
    )
}
