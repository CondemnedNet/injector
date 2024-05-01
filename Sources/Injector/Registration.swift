//
//  Registration.swift
//
//  Copyright © 2024 Condemned.net.
//

import Foundation

public struct Registration: Equatable, Hashable, CustomStringConvertible {
    let type: String
    let arguments: String
    let tags: Set<AnyHashable>

    public var description: String {
        return "Registration - Type: \(type) - Arguments: \(arguments) - Tags: \(tags.map { "\($0.base)" })"
    }

    init<Type, Arguments>(type: Type.Type,
                          arguments: Arguments.Type = Void.self,
                          tags: Set<AnyHashable> = []) {
        self.type = String(reflecting: type)
        self.arguments = String(reflecting: arguments)
        self.tags = tags
    }
}
