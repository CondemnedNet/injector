//
//  Registration.swift
//
//
//  Created by Karl Catigbe on 4/3/24.
//

import Foundation

public struct Registration: Equatable, Hashable, CustomStringConvertible, CustomDebugStringConvertible {
    let type: String
    let arguments: String
    let tags: Set<AnyHashable>
    
    public var description: String {
        return "Registration - Type: \(type) - Arguments: \(arguments) - Tags: \(tags.map({ "\($0.base)" }))"
    }
    
    public var debugDescription: String {
        return description
    }
    
    init<`Type`, Arguments>(type: `Type`.Type,
                            arguments: Arguments.Type = Void.self,
                            tags: Set<AnyHashable> = []) {
        self.type = String(reflecting: type)
        self.arguments = String(reflecting: arguments)
        self.tags = tags
    }
}
