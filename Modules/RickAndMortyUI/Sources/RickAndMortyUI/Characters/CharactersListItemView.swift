//
//  CharactersListItemView.swift
//  
//
//  Created by Vlad Eliseev on 14.04.2024.
//

import RickAndMortyAPI
import SwiftUI

public struct CharactersListItemView: View {
    
    private let character: Character
    
    public init(character: Character) {
        self.character = character
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 14) {
            AsyncImage(
                url: URL(string: character.image),
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                },
                placeholder: {
                    ProgressView()
                }
            )
            .frame(width: 150, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(character.name)
            
            Spacer()
        }
    }
}
