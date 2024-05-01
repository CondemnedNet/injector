//
//  Typealias.swift
//
//  Copyright © 2024 Condemned.net.
//

import Foundation

public typealias Constructor<Type, each Argument> = (any Resolver, repeat each Argument) throws -> Type
public typealias AsyncConstructor<Type, each Argument> = (any Resolver, repeat each Argument) async throws -> Type
