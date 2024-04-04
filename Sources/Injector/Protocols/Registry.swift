//
//  Registry.swift
//  
//
//  Created by Karl Catigbe on 4/3/24.
//

import Foundation

public protocol Registry {
    @discardableResult
    func register<`Type`, each Argument>(_ type: `Type`.Type,
                                         scope: Scope ,
                                         tags: Set<AnyHashable>,
                                         constructor: @escaping Constructor<`Type`, repeat each Argument>)  -> Registration
    
    @discardableResult
    func register<`Type`, each Argument>(_ type: `Type`.Type,
                                         scope: Scope,
                                         tags: AnyHashable...,
                                         constructor: @escaping Constructor<`Type`, repeat each Argument>)  -> Registration
}
