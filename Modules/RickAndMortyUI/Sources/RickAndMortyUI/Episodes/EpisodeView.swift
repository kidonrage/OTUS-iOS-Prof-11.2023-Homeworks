//
//  EpisodeView.swift
//  
//
//  Created by Vlad Eliseev on 14.04.2024.
//

import SwiftUI

public struct EpisodeView: View {
    
    private let name: String
    private let code: String
    
    public init(name: String, code: String) {
        self.name = name
        self.code = code
    }
    
    public var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                Text(code)
                    .font(.caption)
            }
            Spacer()
        }
    }
}
