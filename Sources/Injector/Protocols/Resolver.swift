//
//  Resolver.swift
//
//
//  Created by Karl Catigbe on 4/3/24.
//

import Foundation

public protocol Resolver: AnyObject {
    func locate(_ registration: Registration) -> [Registration: any Injectable]
}

internal extension Resolver {
    func resolve<`Type`, Argument>(_ type: `Type`.Type = `Type`.self,
                                   tags: Set<AnyHashable>,
                                   arguments: Argument) throws -> `Type` {
        let registration = Registration(type: `Type`.self, arguments: Argument.self, tags: tags)
        let dependency = try retrieveRegistration(registration)
        return try resolve(dependency: dependency, arguments: arguments, for: registration)
    }
    
    func resolve<`Type`, Argument>(dependency: any Injectable,
                                   arguments: Argument,
                                   for registration: Registration) throws -> `Type` {
        do {
            // swiftlint:disable:next force_cast
            return try dependency.resolve(self, arguments: arguments) as! `Type`
        } catch {
            if !(error is InjectorError) {
                throw InjectorError.other(error)
            }
            throw error
        }
    }
    
    func retrieveRegistration(_ registration: Registration) throws -> any Injectable {
        let dependencies = locate(registration)
        guard let injectable = dependencies[registration] else {
            throw InjectorError.notFound(registration)
        }
        
        return injectable
    }
    
    func filter(dependencies: [Registration: any Injectable],
                against registration: Registration) -> [Registration: any Injectable] {
        let criteria = Criteria(registration: registration)
        return dependencies.filter { criteria ~= $0 }
    }
}

public extension Resolver {
    func resolve<`Type`, each Argument>(_ type: `Type`.Type = `Type`.self,
                                        tags: AnyHashable...,
                                        arguments: repeat each Argument) throws -> `Type` {
        do {
            return try resolve(type, tags: Set(tags), arguments: (repeat each arguments))
        } catch {
            Log.resolver.error("Unable to resolve \(type, privacy: .sensitive(mask: .hash)) - Error: \(error, privacy: .sensitive(mask: .hash))")
            throw error
        }
    }
}
