//
//  File.swift
//  
//
//  Created by Vlad Eliseev on 07.04.2024.
//

import Foundation

public struct Episode: Identifiable, Decodable {
    
    public let id: Int
    public let name: String
    public let episode: String
}
