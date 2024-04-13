//
//  File.swift
//  
//
//  Created by Vlad Eliseev on 13.04.2024.
//

import Foundation

enum ParserError: Error {
    
    case dataIsEmpty
}

final class Parser {
    
    private let decoder = JSONDecoder()
    
    func parseResults<T: Decodable>(data: Data?, error: Error?) throws -> T {
        guard error == nil else {
            throw error!
        }
        guard let data else {
            throw ParserError.dataIsEmpty
        }
        
        let result = try self.decoder.decode(T.self, from: data)
        return result
    }
}
