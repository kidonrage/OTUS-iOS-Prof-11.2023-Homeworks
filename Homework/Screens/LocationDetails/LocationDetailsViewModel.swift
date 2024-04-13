//
//  LocationDetailsViewModel.swift
//  Homework
//
//  Created by Vlad Eliseev on 07.04.2024.
//

import Foundation
import RickAndMortyAPI

final class LocationDetailsViewModel: ObservableObject {
    
    @Published var model: Location?
    
    @ForceInjected private var api: RickAndMortyAPI
    
    private let locationUrl: String
    
    init(locationUrl: String) {
        self.locationUrl = locationUrl
    }
    
    func handleOnAppear() {
        api.loadLocation(locationUrl: URL(string: locationUrl)!) { locationModel in
            self.model = locationModel
        }
    }
}
