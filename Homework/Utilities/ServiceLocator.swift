//
//  ServiceLocator.swift
//  Homework
//
//  Created by Vlad Eliseev on 13.04.2024.
//

import Foundation

final class ServiceLocator {
    
    static let shared = ServiceLocator()
    
    private var services = [String:Any]()
    
    private init() {}
    
    func register<T: Any>(service: T) {
        let id = getId(ofType: T.self)
        services[id] = service
    }
    
    func forceGet<T: Any>() -> T {
        let id = getId(ofType: T.self)
        guard let service = services[id], let typedService = service as? T else {
            fatalError("Service is not registered")
        }
        return typedService
    }
    
    func get<T: AnyObject>() -> T? {
        let id = getId(ofType: T.self)
        return services[id] as? T
    }
    
    private func getId<T>(ofType type: T.Type) -> String {
        return String(describing: T.self)
    }
}
