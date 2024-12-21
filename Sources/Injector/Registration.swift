//
//  Registration.swift
//
//  Copyright © 2024 Condemned.net.
//

import Foundation

public struct Registration: Sendable, Equatable, Hashable, CustomStringConvertible {
    let type: String
    let arguments: String
    let tags: Set<String>

    public var description: String {
        return "Registration - Type: \(type) - Arguments: \(arguments) - Tags: \(tags.map { "\($0)" })"
    }

    init<Type, Arguments>(type: Type.Type,
                          arguments: Arguments.Type = Void.self,
                          tags: Set<String> = []) {
        self.type = String(reflecting: type)
        self.arguments = String(reflecting: arguments)
        self.tags = tags
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(arguments)
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.type == rhs.type && lhs.arguments == rhs.arguments
    }
}
