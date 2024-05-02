//
//  Criteria.swift
//
//  Copyright © 2024 Condemned.net.
//

import Foundation

struct Criteria: Equatable {
    let type: String?
    let tags: TagSet?
    let arguments: String?

    let scope: Scope?

    init<Type, Argument>(_ type: Type.Type,
                         tags: TagSet? = nil,
                         arguments: Argument.Type,
                         scope: Scope? = nil) {
        self.type = String(reflecting: type)
        self.tags = tags
        self.arguments = String(reflecting: arguments)
        self.scope = scope
    }

    init<Type>(_ type: Type.Type,
               tags: TagSet? = nil,
               scope: Scope? = nil) {
        self.type = String(reflecting: type)
        self.tags = tags
        arguments = nil
        self.scope = scope
    }

    init<Argument>(tags: TagSet? = nil,
                   arguments: Argument.Type,
                   scope: Scope? = nil) {
        type = nil
        self.tags = tags
        self.arguments = String(reflecting: arguments)
        self.scope = scope
    }

    init(tags: TagSet? = nil,
         scope: Scope? = nil) {
        type = nil
        self.tags = tags
        arguments = nil
        self.scope = scope
    }

    init(registration: Registration,
         scope: Scope? = nil) {
        type = registration.type
        tags = .equals(registration.tags)
        arguments = registration.arguments
        self.scope = scope
    }
}

infix operator ~=: ComparisonPrecedence

extension Criteria {
    enum Comparator {
        case equals
        case contains
    }

    struct TagSet: Equatable {
        let tags: Set<AnyHashable>
        let comparator: Comparator

        private init(tags: Set<AnyHashable>, comparator: Comparator = .equals) {
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

    static func ~= (criteria: Criteria, registration: Registration) -> Bool {
        let type = criteria.type ?? registration.type
        let tags = criteria.tags ?? .equals(registration.tags)
        let arguments = criteria.arguments ?? registration.arguments
        return type == registration.type && tags ~= registration.tags && arguments == registration.arguments
    }

    static func ~= (criteria: Criteria, resolvable: any Injectable) -> Bool {
        let scope = criteria.scope ?? resolvable.scope
        return scope == resolvable.scope
    }

    static func ~= (criteria: Criteria, rhs: Dictionary<Registration, any Injectable>.Element) -> Bool {
        criteria ~= rhs.key && criteria ~= rhs.value
    }
}
