//
//  Registration.swift
//  
//
//  Created by Karl Catigbe on 4/3/24.
//

import Foundation


public struct Registration: Equatable, Hashable, CustomStringConvertible {
    
    let type: String
    let arguments: String
    let tags: Set<AnyHashable>
    
    
    init<`Type`, Arguments>(type: `Type`.Type,
                          arguments: Arguments.Type = Void.self,
                          tags: Set<AnyHashable> = []) {
        self.type = String(reflecting: type)
        self.arguments = String(reflecting: arguments)
        self.tags = tags
    }
    
    init<`Type`, Arguments>(type: `Type`.Type,
                          arguments: Arguments.Type = Void.self,
                            tags: AnyHashable...) {
        self.init(type: type, arguments: arguments, tags: Set(tags))
    }
            
    public var description: String {
        return "Registration - Type: \(type) - Arguments: \(arguments) - Tags: \(tags)"
    }
    
}
