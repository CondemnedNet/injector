//
//  Criteria.swift
//
//
//  Created by Karl Catigbe on 4/3/24.
//

import Foundation

struct Criteria: Equatable {
    let type: String?
    let tags: Tags?
    let arguments: String?
    
    let scope: Scope?
    
    init<`Type`, Argument>(_ type: `Type`.Type,
                           tags: Tags? = nil,
                           arguments: Argument.Type,
                           scope: Scope? = nil) {
        self.type = String(reflecting: type)
        self.tags = tags
        self.arguments = String(reflecting: arguments)
        self.scope = scope
    }
    
    init<`Type`>(_ type: `Type`.Type,
                 tags: Tags? = nil,
                 scope: Scope? = nil) {
        self.type = String(reflecting: type)
        self.tags = tags
        self.arguments = nil
        self.scope = scope
    }
    
    init<Argument>(tags: Tags? = nil,
                   args: Argument.Type,
                   scope: Scope? = nil) {
        self.type = nil
        self.tags = tags
        self.arguments = String(reflecting: args)
        self.scope = scope
    }
    
    init(tags: Tags? = nil,
         scope: Scope? = nil) {
        self.type = nil
        self.tags = tags
        self.arguments = nil
        self.scope = scope
    }
    
    init(registration: Registration,
         scope: Scope? = nil) {
        self.type = registration.type
        self.tags = .equals(registration.tags)
        self.arguments = registration.arguments
        self.scope = scope
    }
}

// swiftlint:disable static_operator
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
// swiftlint:enable static_operator

extension Criteria {
    enum Comparator {
        case equals
        case contains
    }
    
    struct Tags: Equatable {
        let tags: Set<AnyHashable>
        let comparator: Comparator
        
        init(tags: Set<AnyHashable>, comparator: Comparator = .equals) {
            self.tags = tags
            self.comparator = comparator
        }
        
        static func equals(_ tags: Set<AnyHashable>) -> Self {
            .init(tags: tags)
        }
        
        static func equals(_ tags: AnyHashable...) -> Self {
            .equals(Set(tags))
        }
        
        static func contains(_ tags: Set<AnyHashable>) -> Self {
            .init(tags: tags, comparator: .contains)
        }
        
        static func contains(_ tags: AnyHashable...) -> Self {
            .contains(Set(tags))
        }
        
        static func ~= (criterion: Self, tags: Set<AnyHashable>) -> Bool {
            switch criterion.comparator {
            case .equals:
                return criterion.tags == tags
                
            case .contains:
                return criterion.tags.isSubset(of: tags)
            }
        }
    }
}
