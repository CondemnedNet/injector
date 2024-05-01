//
//  Dependency.swift
//
//
//  Created by Karl Catigbe on 4/3/24.
//

import Foundation

public class Dependency: Injectable {
    public let scope: Scope
    
    private let constructor: ConstructorType
    
    private var resolvedInstance: Any?
    private let queue: DispatchQueue
    
    init<`Type`, each Argument>(registration: Registration,
                                scope: Scope = .unique,
                                constructor: @escaping Constructor<`Type`, repeat each Argument>) {
        self.scope = scope
        self.queue = DispatchQueue(label: "\(registration)")
        
        self.constructor = .sync { container, arg in
            // swiftlint:disable:next force_cast
            let args = arg as! (repeat each Argument)
            return try constructor(container, repeat each args)
        }
    }
    
    init<`Type`, each Argument>(registration: Registration,
                                scope: Scope = .unique,
                                constructor: @escaping AsyncConstructor<`Type`, repeat each Argument>) {
        self.scope = scope
        self.queue = DispatchQueue(label: "\(registration)")
        
        self.constructor = .async { container, arg in
            // swiftlint:disable:next force_cast
            let args = arg as! (repeat each Argument)
            return try await constructor(container, repeat each args)
        }
    }
    
    public func resolve(_ container: any Resolver,
                        arguments: Any) throws -> Any {
        // If we've previously resolved this, return it, otherwise try to resolve it
        guard let resolvedInstance else {
            guard case .sync(let constructor) = constructor else {
                throw InjectorError.requiresAsync("Type was registered with an async constructor!")
            }
            return try resolveInstance(from: container, arguments: arguments, constructor: constructor)
            
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
    
    public func resolve(_ container: any Resolver,
                        arguments: Any) async throws -> Any {
        // If we've previously resolved this, return it, otherwise try to resolve it
        guard let resolvedInstance else {
            switch scope {
            case .unique:
                // resolve it
                switch constructor {
                case .sync(let constructor):
                    return try  resolveInstance(from: container, arguments: arguments, constructor: constructor)
                case .async(let constructor):
                    return try await resolveInstance(from: container, arguments: arguments, constructor: constructor)
                }
            case .singleton:
                switch constructor {
                case .sync(let constructor):
                    return try queue.sync {
                        
                        let instance = try resolveInstance(from: container, arguments: arguments, constructor: constructor)
                        resolvedInstance = instance
                        return instance
                    }
                case .async(let constructor):
                    let instance = try await resolveInstance(from: container, arguments: arguments, constructor: constructor)
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
    
    private func resolveInstance(from container: any Resolver,
                                 arguments: Any,
                                 constructor: (any Resolver, Any) async throws -> Any) async throws -> Any {
        return try await constructor(container, arguments)
    }
}


private extension Dependency {
    enum ConstructorType {
        case sync( (any Resolver, Any) throws -> Any )
        case async( (any Resolver, Any) async throws -> Any )
    }
}
