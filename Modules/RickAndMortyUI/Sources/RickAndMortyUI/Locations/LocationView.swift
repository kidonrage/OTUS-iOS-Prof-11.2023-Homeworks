//
//  File.swift
//  
//
//  Created by Vlad Eliseev on 14.04.2024.
//

import SwiftUI
import RickAndMortyAPI

public struct LocationView: View {
    
    private let location: Location
    
    public init(location: Location) {
        self.location = location
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(location.name)
            Text(location.dimension)
                .font(.caption)
        }
    }
}
