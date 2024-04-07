//
//  Character.swift
//  Homework
//
//  Created by Vlad Eliseev on 07.04.2024.
//

import Foundation

public struct Character: Decodable {
    
    public struct Location: Decodable {
        
        public let url: String
        public let name: String
        
        public init(url: String, name: String) {
            self.url = url
            self.name = name
        }
    }
    
    public let id: Int
    public let name: String
    public let image: String
    public let url: String
    public let location: Location
    
    public init(id: Int, name: String, image: String, url: String, location: Location) {
        self.id = id
        self.name = name
        self.image = image
        self.url = url
        self.location = location
    }
}

public struct CharactersResponse: Decodable {
    
    public let info: ResponseInfo
    public let results: [Character]
}
