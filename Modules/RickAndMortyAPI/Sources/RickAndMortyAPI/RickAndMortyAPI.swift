//
//  RickAndMortyAPI.swift
//  Homework
//
//  Created by Vlad Eliseev on 06.04.2024.
//

import Foundation

public final class RickAndMortyAPI {
    
    public static let shared = RickAndMortyAPI()
    
    private let decoder = JSONDecoder()
    
    private init() {}
    
    public func getCharacters(page: Int, completionHandler: @escaping ([Character]) -> Void) {
        let url = URL(string: "https://rickandmortyapi.com/api/character/?page=\(page)")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
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
                DispatchQueue.main.async {
                    completionHandler(responseObj.results)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completionHandler([])
                }
            }
        }.resume()
    }
    
    public func loadLocations(page: Int, completionHandler: @escaping (LocationsResponse?) -> Void) {
        let url = URL(string: "https://rickandmortyapi.com/api/location/?page=\(page)")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                assertionFailure(error?.localizedDescription ?? "Unknown error")
                return
            }
            guard let data else {
                assertionFailure("Data is empty")
                return
            }
            do {
                let responseObj = try self.decoder.decode(LocationsResponse.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(responseObj)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }.resume()
    }
    
    public func loadLocation(locationUrl: URL, completionHandler: @escaping (Location?) -> Void) {
        let request = URLRequest(url: locationUrl)
        URLSession.shared.dataTask(with: request, completionHandler: { data, respone, error in
            guard error == nil else {
                assertionFailure(error?.localizedDescription ?? "Unknown error")
                return
            }
            guard let data else {
                assertionFailure("Data is empty")
                return
            }
            do {
                let location = try self.decoder.decode(Location.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(location)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }).resume()
    }
}
