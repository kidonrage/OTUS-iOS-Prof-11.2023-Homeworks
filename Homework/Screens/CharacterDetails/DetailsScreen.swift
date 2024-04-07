//
//  DetailsScreen.swift
//  Homework
//
//  Created by Vlad Eliseev on 06.04.2024.
//

import SwiftUI
import CustomNavigationStack
import RickAndMortyAPI

struct CharacterDetailsScreen: View {
    
    @EnvironmentObject var navigationVM: NavigationViewModel
    
    private let character: Character
    
    var imageUrl: String {
        character.image
    }
    var title: String {
        character.name
    }
    
    init(character: Character) {
        self.character = character
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                VStack(alignment: .leading) {
                    AsyncImage(
                        url: URL(string: imageUrl),
                        content: { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                        },
                        placeholder: {
                            ProgressView()
                        }
                    )
                    .frame(width: geometry.size.width, height: geometry.size.width)
                    
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.largeTitle)
                            .padding(.vertical, 8)
                        
                        Button(action: {
                            navigationVM.push(screenView: LocationDetailsScreen(viewModel: .init(locationUrl: character.location.url)))
                        }, label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Origin")
                                        .font(.caption2)
                                    Text(character.location.name)
                                        .font(.title2)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        })
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer()
                }
                .ignoresSafeArea()
            }
            Button(action: {
                navigationVM.pop()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                
            })
            .position(x: geometry.size.width - 32, y: 16)
        })
    }
}

#Preview {
    CharacterDetailsScreen(
        character: Character(id: 0, name: "Test", image: "", url: "", location: .init(url: "", name: "Earth"))
    )
}
