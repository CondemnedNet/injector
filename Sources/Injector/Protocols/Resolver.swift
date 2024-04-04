//
//  Resolver.swift
//
//
//  Created by Karl Catigbe on 4/3/24.
//

import Foundation

public protocol Resolver { }

public extension Resolver where Self: Locator, Self: Registry {
    func resolve<`Type`, Argument>(_ type: `Type`.Type = `Type`.self,
                                   tags: Set<AnyHashable>,
                                   arguments: Argument) throws -> `Type` {
        let registration = Registration(type: `Type`.self, arguments: Argument.self, tags: tags)
        let dependency = try locate(registration)
        return try resolve(dependency: dependency, arguments: arguments, for: registration)
    }
    
    func resolve<`Type`, Argument>(_ type: `Type`.Type = `Type`.self,
                                   tags: AnyHashable...,
                                   arguments: Argument) throws -> `Type` {
        return try resolve(type, tags: Set(tags), arguments: arguments)
    }
    
    // MARK: - Parameter Packs
    
    func resolve<`Type`, each Argument>(_ type: `Type`.Type = `Type`.self,
                                        tags: Set<AnyHashable>,
                                        arguments: repeat each Argument) throws -> `Type` {
        return try resolve(type, tags: tags, arguments: (repeat each arguments))
    }
    
    func resolve<`Type`, each Argument>(_ type: `Type`.Type = `Type`.self,
                                        tags: AnyHashable...,
                                        arguments: repeat each Argument) throws -> `Type` {
        return try resolve(type, tags: Set(tags), arguments: repeat each arguments)
    }
    
    
    func resolve<`Type`, Argument>(dependency: any Injectable,
                                   arguments: Argument,
                                   for registration: Registration) throws -> `Type`{
        do {
            return try dependency.resolve(self, arguments: arguments) as! `Type`
        } catch {
            if !(error is InjectorError) {
                throw InjectorError.other(error)
            }
            throw error
        }
    }
}
