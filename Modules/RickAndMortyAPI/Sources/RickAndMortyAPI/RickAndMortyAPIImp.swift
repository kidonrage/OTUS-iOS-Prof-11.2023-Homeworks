//
//  RickAndMortyAPI.swift
//  Homework
//
//  Created by Vlad Eliseev on 06.04.2024.
//

import Foundation

public protocol RickAndMortyAPI: AnyObject {
    
    func getCharacters(page: Int, completionHandler: @escaping ([Character]) -> Void)
    func loadEpisodes(page: Int, completionHandler: @escaping (EpisodesReponse?) -> Void)
    func loadLocations(page: Int, completionHandler: @escaping (LocationsResponse?) -> Void)
    func loadLocation(locationUrl: URL, completionHandler: @escaping (Location?) -> Void)
}

public final class RickAndMortyAPIImp: RickAndMortyAPI {
    
    private let parser = Parser()
    
    // MARK: - Initializers
    public init() {}
    
    // MARK: - Public
    
    public func getCharacters(page: Int, completionHandler: @escaping ([Character]) -> Void) {
        let url = URL(string: "https://rickandmortyapi.com/api/character/?page=\(page)")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            //            sleep(2)
            do {
                let responseObj: CharactersResponse? = try self?.parser.parseResults(data: data, error: error)
                DispatchQueue.main.async {
                    completionHandler(responseObj?.results ?? [])
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
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            //            sleep(2)
            do {
                let responseObj: LocationsResponse? = try self?.parser.parseResults(data: data, error: error)
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
    
    public func loadEpisodes(page: Int, completionHandler: @escaping (EpisodesReponse?) -> Void) {
        let url = URL(string: "https://rickandmortyapi.com/api/episode/?page=\(page)")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            //            sleep(2)
            do {
                let responseObj: EpisodesReponse? = try self?.parser.parseResults(data: data, error: error)
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
        URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            //            sleep(2)
            do {
                let responseObj: Location? = try self?.parser.parseResults(data: data, error: error)
                DispatchQueue.main.async {
                    completionHandler(responseObj)
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
