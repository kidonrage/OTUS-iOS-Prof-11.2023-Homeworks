//
//  RickAndMortyAPI.swift
//  Homework
//
//  Created by Vlad Eliseev on 06.04.2024.
//

import Foundation

struct Character: Decodable {
    
    let id: Int
    let name: String
    let image: String
    let url: String
}

struct ResponseInfo: Decodable {
    
    let count: Int
    let pages: Int
}

struct CharactersResponse: Decodable {
    
    let info: ResponseInfo
    let results: [Character]
}

final class RickAndMortyAPI {
    
    static let shared = RickAndMortyAPI()
    
    private let decoder = JSONDecoder()
    
    private init() {}
    
    func getCharacters(completionHandler: @escaping ([Character]) -> Void) {
        let url = URL(string: "https://rickandmortyapi.com/api/character")!
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                assertionFailure(error?.localizedDescription ?? "Unknown error")
                return
            }
            guard let data else {
                assertionFailure("Data is empty")
                return
            }
            do {
                let responseObj = try self.decoder.decode(CharactersResponse.self, from: data)
                completionHandler(responseObj.results)
            } catch {
                print(error.localizedDescription)
                completionHandler([])
            }
        }
        
        dataTask.resume()
    }
}
