//
//  Injected.swift
//  Homework
//
//  Created by Vlad Eliseev on 13.04.2024.
//

import Foundation

@propertyWrapper
struct ForceInjected<Service> {
    
    var wrappedValue: Service {
        get {
            return ServiceLocator.shared.forceGet()
        }
    }
}
