//
//  Collaborator.swift
//
//  Copyright © 2024 Condemned.net.
//

import Foundation

public protocol Collaborator: AnyObject {
    var collaborators: [any Resolver] { get }

    func collaborate(with collaborators: [any Resolver])
}

public extension Collaborator {
    func collaborate(with collaborators: any Resolver...) {
        collaborate(with: Array(collaborators))
    }
}
