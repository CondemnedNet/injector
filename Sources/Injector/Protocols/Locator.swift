//
//  Locator.swift
//  
//
//  Created by Karl Catigbe on 4/3/24.
//

public protocol Locator {
    func locate(_ criteria: Criteria) -> [Registration: any Injectable]
}

extension Locator {
    func locate(_ registration: Registration) throws -> any Injectable {
        let dependencies = locate(Criteria(registration: registration))
        
        guard let injectable = dependencies[registration] else {
            throw InjectorError.notFound(registration)
        }
        
        return injectable
    }
}
