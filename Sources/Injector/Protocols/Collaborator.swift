//
//  Collaborator.swift
//
//
//  Created by Karl Catigbe on 4/10/24.
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
