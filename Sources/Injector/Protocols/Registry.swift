//
//  Registry.swift
//
//  Copyright © 2024 Condemned.net.
//

import Foundation

public protocol Registry {
    @discardableResult
    func register<Type, each Argument>(_ type: Type.Type,
                                       scope: Scope,
                                       tags: Set<String>,
                                       constructor: @escaping Constructor < Type, repeat each Argument>) -> Registration

    // MARK: - Async

    @discardableResult
    func register<Type, each Argument>(_ type: Type.Type,
                                       scope: Scope,
                                       tags: Set<String>,
                                       constructor: @escaping AsyncConstructor < Type, repeat each Argument>) -> Registration
}

public extension Registry {
    @discardableResult
    func register<Type, each Argument>(_ type: Type.Type = Type.self,
                                       scope: Scope = .unique,
                                       tags: String...,
                                       constructor: @escaping (any Resolver, repeat each Argument) throws -> Type) -> Registration {
        let constructor: Constructor < `Type`, repeat each Argument> = { (container: any Resolver, args: repeat each Argument) in
            try constructor(container, repeat each args)
        }

        return register(type, scope: scope, tags: Set(tags), constructor: constructor)
    }

    @discardableResult
    func register<Type>(_ type: Type.Type = Type.self,
                        scope: Scope = .unique,
                        tags: String...,
                        instance: @escaping @autoclosure () -> Type) -> Registration {
        let constructor: Constructor<Type, Void> = { _, _ in
            instance()
        }
        return register(type, scope: scope, tags: Set(tags), constructor: constructor)
    }

    // MARK: - Async

    @discardableResult
    func register<Type, each Argument>(_ type: Type.Type = Type.self,
                                       scope: Scope = .unique,
                                       tags: String...,
                                       constructor: @escaping (any Resolver, repeat each Argument) async throws -> Type) -> Registration {
        let constructor: AsyncConstructor < `Type`, repeat each Argument> = { (container: any Resolver, args: repeat each Argument) in
            try await constructor(container, repeat each args)
        }

        return register(type, scope: scope, tags: Set(tags), constructor: constructor)
    }

    @discardableResult
    func register<Type>(_ type: Type.Type = Type.self,
                        scope: Scope = .unique,
                        tags: String...,
                        instance: @escaping @autoclosure () async -> Type) async -> Registration {
        let constructor: AsyncConstructor<Type, Void> = { _, _ in
            await instance()
        }
        return register(type, scope: scope, tags: Set(tags), constructor: constructor)
    }
}
