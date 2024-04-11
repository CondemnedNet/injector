//
//  Dependency.swift
//
//
//  Created by Karl Catigbe on 4/3/24.
//

import Foundation

public class Dependency: Injectable {
    public let scope: Scope
    
    private let constructor: (any Resolver, Any) throws -> Any
    
    private var resolvedInstance: Any?
    private let queue: DispatchQueue
    
    init<`Type`, each Argument>(registration: Registration,
                                scope: Scope = .unique,
                                constructor: @escaping Constructor<`Type`, repeat each Argument>) {
        self.scope = scope
        self.queue = DispatchQueue(label: "\(registration)")
        
        self.constructor = { container, arg in
            // swiftlint:disable:next force_cast
            let args = arg as! (repeat each Argument)
            return try constructor(container, repeat each args)
        }
    }
    
    public func resolve(_ container: any Resolver,
                        arguments: Any) throws -> Any {
        // If we've previously resolved this, return it, otherwise try to resolve it
        guard let resolvedInstance else {
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
        return resolvedInstance
    }
    
    private func resolveInstance(from container: any Resolver,
                                 arguments: Any,
                                 constructor: (any Resolver, Any) throws -> Any) throws -> Any {
        return try constructor(container, arguments)
    }
}
