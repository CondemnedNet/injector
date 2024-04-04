//
//  Criteria.swift
//
//
//  Created by Karl Catigbe on 4/3/24.
//

import Foundation

public struct Criteria: Equatable {
    public let type: String?
    public let tags: Tags?
    public let arguments: String?
    
    public let scope: Scope?
    
    public init<`Type`, Argument>(_ type: `Type`.Type,
                                  tags: Tags? = nil,
                                  arguments: Argument.Type,
                                  scope: Scope? = nil) {
        self.type = String(reflecting: type)
        self.tags = tags
        self.arguments = String(reflecting: arguments)
        self.scope = scope
    }
    
    public init<`Type`>(_ type: `Type`.Type,
                        tags: Tags? = nil,
                        scope: Scope? = nil) {
        self.type = String(reflecting: type)
        self.tags = tags
        self.arguments = nil
        self.scope = scope
    }
    
    public init<Argument>(tags: Tags? = nil,
                          args: Argument.Type,
                          scope: Scope? = nil) {
        self.type = nil
        self.tags = tags
        self.arguments = String(reflecting: args)
        self.scope = scope
    }
    
    public init(tags: Tags? = nil,
                scope: Scope? = nil) {
        self.type = nil
        self.tags = tags
        self.arguments = nil
        self.scope = scope
    }
    
    public init(registration: Registration,
                scope: Scope? = nil) {
        self.type = registration.type
        self.tags = .equals(registration.tags)
        self.arguments = registration.arguments
        self.scope = scope
    }
}

func ~= (criteria: Criteria, registration: Registration) -> Bool {
    let type = criteria.type ?? registration.type
    let tags = criteria.tags ?? .equals(registration.tags)
    let arguments = criteria.arguments ?? registration.arguments
    return type == registration.type && tags ~= registration.tags && arguments == registration.arguments
}

func ~= (criteria: Criteria, resolvable: any Injectable) -> Bool {
    let scope = criteria.scope ?? resolvable.scope
    return scope == resolvable.scope
}

func ~= (criteria: Criteria, rhs: Dictionary<Registration, any Injectable>.Element) -> Bool {
    criteria ~= rhs.key && criteria ~= rhs.value
}

public extension Criteria {
    struct Tags: Equatable {
        public enum Comparator {
            case equals
            case contains
        }
        
        public let tags: Set<AnyHashable>
        public let comparator: Comparator
        
        public init(tags: Set<AnyHashable>, comparator: Comparator = .equals) {
            self.tags = tags
            self.comparator = comparator
        }
        
        static func equals(_ tags: Set<AnyHashable>) -> Tags {
            .init(tags: tags)
        }
        
        static func equals(_ tags: AnyHashable...) -> Tags {
            .equals(Set(tags))
        }
        
        static func contains(_ tags: Set<AnyHashable>) -> Tags {
            .init(tags: tags, comparator: .contains)
        }
        
        static func contains(_ tags: AnyHashable...) -> Tags {
            .contains(Set(tags))
        }
        
        static func ~= (criterion: Tags, tags: Set<AnyHashable>) -> Bool {
            switch criterion.comparator {
            case .equals:
                return criterion.tags == tags
            case .contains:
                return criterion.tags.isSubset(of: tags)
            }
        }
    }
}
