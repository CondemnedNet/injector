//
//  Injectable.swift
//
//
//  Created by Karl Catigbe on 4/3/24.
//

import Foundation

public protocol Injectable: AnyObject {
    var scope: Scope { get }
    func resolve(_ container: any Resolver, arguments: Any) throws -> Any
}

public class Dependency: Injectable {
    public let scope: Scope
    
    private let constructor: (any Resolver, Any) throws -> Any
    
    private var resolvedInstance: Any? = nil
    private let queue: DispatchQueue
    
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
    
    public func resolve(_ container: any Resolver,
                        arguments: Any) throws -> Any {
        // If we've previously resolved this, return it.
        guard resolvedInstance == nil else {
            return resolvedInstance!
        }
        
        switch scope {
        case .unique:
            // resolve it
            return try resolveInstance(from: container, arguments: arguments, constructor: constructor)
        case .singleton:
            return try queue.sync {
                // resolve it, and set resolvedInstance to it.
                let instance = try resolveInstance(from: container, arguments: arguments, constructor: constructor)
                resolvedInstance = instance
                return instance
            }
        }
    }
    
    private func resolveInstance(from container: any Resolver,
                                 arguments: Any,
                                 constructor: (any Resolver, Any) throws -> Any) throws -> Any {
        return try constructor(container, arguments)
    }
}
