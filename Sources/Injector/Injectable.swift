//
//  Injectable.swift
//
//
//  Created by Karl Catigbe on 4/3/24.
//

import Foundation

public protocol Injectable {
    var scope: Scope { get }
    func resolve(_ container: any Registry, arguments: Any) throws -> Any
}

class Dependency: Injectable {
    let scope: Scope
    
    private var resolvedInstance: Any? = nil
    private let queue: DispatchQueue
    
    let constructor: (any Registry, Any) throws -> Any
    
    init<`Type`, each Argument>(registration: Registration,
                                scope: Scope = .unique,
                                constructor: @escaping Constructor<`Type`, repeat each Argument>) {
        self.scope = scope
        self.queue = DispatchQueue(label: "\(registration)")
        
        self.constructor = { container, arg in
            let args = arg as! (repeat each Argument)
            return try constructor(container, repeat each args)
        }
    }
    
    func resolve(_ container: any Registry, arguments: Any) throws -> Any {
        // If we've previously resolved this, return it.
        guard resolvedInstance != nil else {
            return resolvedInstance!
        }
        
        switch scope {
        case .unique:
            // resolve it
            return try resolveInstance(from: container, argumeents: arguments, constructor: constructor)
        case .singleton:
            return try queue.sync {
                // resolve it, and set resolvedInstance to it.
                let instance = try resolveInstance(from: container, argumeents: arguments, constructor: constructor)
                resolvedInstance = instance
                return instance
            }
        }
        
    }
    
    
    private func resolveInstance(from container: any Registry, argumeents: Any, constructor: (any Registry, Any) throws -> Any) throws -> Any {
        do {
            return try constructor(container, argumeents)
        } catch {
            //          throw ResolutionError.Reason.error(error)
            throw error
        }
    }
}
