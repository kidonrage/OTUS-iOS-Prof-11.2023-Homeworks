//
//  Location.swift
//  Homework
//
//  Created by Vlad Eliseev on 07.04.2024.
//

import Foundation

public struct Location: Identifiable, Decodable {
    
    public let id: Int
    public let name: String
    public let type: String
    public let dimension: String
}

public struct LocationsResponse: Decodable {
    
    public let info: ResponseInfo
    public let results: [Location]
}
