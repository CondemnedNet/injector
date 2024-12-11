//
//  Container.swift
//
//  Copyright © 2024 Condemned.net.
//

import Foundation

public enum Scope: String {
    case unique
    case singleton
}

public class Container {
    private let identifier: String

    private(set) var parent: Container?
    private(set) var dependencies: [Registration: any Injectable] = [:]

    private var weakCollaborators: [WeakWrapper<Container>] = []
    private let queue = DispatchQueue(label: "container", attributes: .concurrent)

    public var collaborators: [any Resolver] {
        return weakCollaborators.compactMap { $0.value }
    }

    public init(parent: Container? = nil, identifier: String = UUID().uuidString) {
        self.identifier = identifier
        Log.general.debug("\(self) Initializing with parent: \(String(describing: parent))")
        self.parent = parent
    }

    public init(parent: Container? = nil, identifier: String = UUID().uuidString, builder: (Container) -> Void = { _ in }) {
        self.identifier = identifier
        Log.general.debug("\(self) Initializing with parent: \(String(describing: parent))")
        self.parent = parent
        builder(self)
    }
}

extension Container: Collaborator {
    public func collaborate(with collaborators: [any Resolver]) {
        Log.collaborator.debug("\(self) Collaborating with\n\t\(collaborators.map { "\($0)" }.joined(separator: "\n\t"), privacy: .sensitive)")
        let compacted = collaborators
            .filter { $0 !== self }
            .compactMap { resolver -> WeakWrapper<Container>? in
                guard let weakContainer = resolver as? Container
                else {
                    return nil
                }
                return WeakWrapper(value: weakContainer)
            }
        queue.sync(flags: .barrier) {
            self.weakCollaborators.append(contentsOf: compacted)
        }

        for weakCollab in compacted
            .compactMap({ $0.value }) {
            guard !weakCollab.weakCollaborators.contains(where: { weakWrapper in
                weakWrapper.value === self
            }) else { break }

            weakCollab.weakCollaborators.append(WeakWrapper(value: self))
        }
    }
}

extension Container: Registry {
    // MARK: Register Dependencies

    @discardableResult
    public func register<Type, each Argument>(_ type: Type.Type = Type.self,
                                              scope: Scope = .unique,
                                              tags: Set<AnyHashable>,
                                              constructor: @escaping Constructor < Type, repeat each Argument>) -> Registration {
        let registration = Registration(type: type, arguments: (repeat each Argument).self, tags: tags)
        let dependency = Dependency(registration: registration, scope: scope, constructor: constructor)

        Log.registry.debug("\(registration, privacy: .sensitive(mask: .hash)) Scope: \(scope.rawValue, privacy: .public)")
        commit(registration: registration, dependency: dependency)
        return registration
    }

    @discardableResult
    public func register<Type, each Argument>(_ type: Type.Type = Type.self,
                                              scope: Scope = .unique,
                                              tags: Set<AnyHashable>,
                                              constructor: @escaping AsyncConstructor < Type, repeat each Argument>) -> Registration {
        let registration = Registration(type: type, arguments: (repeat each Argument).self, tags: tags)
        let dependency = Dependency(registration: registration, scope: scope, constructor: constructor)

        Log.registry.debug("\(registration, privacy: .sensitive(mask: .hash)) Scope: \(scope.rawValue, privacy: .public)")
        commit(registration: registration, dependency: dependency)
        return registration
    }

    private func commit(registration: Registration, dependency: any Injectable) {
        queue.sync(flags: .barrier) {
            dependencies[registration] = dependency
        }
    }
}

extension Container: Resolver {
    public func locate(_ registration: Registration) -> [Registration: any Injectable] {
        return locate(registration, collaborator: nil)
    }

    private func locate(_ registration: Registration, collaborator: Container?) -> [Registration: any Injectable] {
        queue.sync {
            var entries = filter(dependencies: dependencies, against: registration)
            if let parent {
                let parentRegs = parent.locate(registration)
                entries = parentRegs.merging(entries, uniquingKeysWith: { _, new in new })
            }

            guard entries.isEmpty
            else {
                Log.collaborator.trace("\(self) found \(registration.type) - tags: \(registration.tags)")
                return entries
            }

            let collaborators = weakCollaborators
                .reversed()
                .compactMap { $0.value }
                .filter { $0 !== collaborator }
                .filter { $0 !== self }
            return locate(registration, collaborators: collaborators)
        }
    }

    private func locate(_ registration: Registration, collaborators: [Container]) -> [Registration: any Injectable] {
        for collaborator in collaborators {
            Log.collaborator.trace("\(self) is trying to locate \(registration.type) - \(registration.tags) in \(collaborator)")
            let located = collaborator.locate(registration, collaborator: self)
            if !located.isEmpty {
                return located
            }
        }
        return [:]
    }
}

extension Container: CustomStringConvertible {
    public var description: String {
        return "Container: \(identifier)"
    }
}
