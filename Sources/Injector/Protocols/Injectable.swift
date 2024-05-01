//
//  Injectable.swift
//
//  Copyright © 2024 Condemned.net.
//

import Foundation

public protocol Injectable: AnyObject {
    var scope: Scope { get }

    func resolve(_ container: any Resolver, arguments: Any) throws -> Any
    func resolve(_ container: any Resolver, arguments: Any) async throws -> Any
}
