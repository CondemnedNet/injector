//
//  Typealias.swift
//
//
//  Created by Karl Catigbe on 4/8/24.
//

import Foundation

public typealias Constructor<`Type`, each Argument> = (any Resolver, repeat each Argument) throws -> `Type`
public typealias AsyncConstructor<`Type`, each Argument> = (any Resolver, repeat each Argument) async throws -> `Type`
