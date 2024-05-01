import Foundation

public enum Scope: String {
    case unique
    case singleton
}

public class Container {
    internal private(set) var parent: Container?
    internal private(set) var dependencies: [Registration: any Injectable] = [:]
    
    private var weakCollaborators: [WeakWrapper<Container>] = []
    private let queue = DispatchQueue(label: "container", attributes: .concurrent)
    
    public var collaborators: [any Resolver] {
        return weakCollaborators.compactMap({ $0.value })
    }
    
    init(parent: Container? = nil) {
        Log.general.debug("Initializing with parent: \(String(describing: parent))")
        self.parent = parent
    }
}

extension Container: Collaborator {
    public func collaborate(with collaborators: [any Resolver]) {
        Log.collaborator.notice("Collaborating with \(collaborators.map({ "\($0)" }).joined(), privacy: .sensitive)")
        queue.sync(flags: .barrier) {
            let compacted = collaborators
                .filter({ $0 !== self })
                .compactMap({ resolver -> WeakWrapper<Container>? in
                    guard let weakContainer = resolver as? Container else {
                        return nil
                    }
                    return WeakWrapper(value: weakContainer)
                })
            self.weakCollaborators.append(contentsOf: compacted)
        }
    }
}

extension Container: Registry {
    // MARK: Register Dependencies
    @discardableResult
    public func register<`Type`, each Argument>(_ type: `Type`.Type = `Type`.self,
                                                scope: Scope = .unique,
                                                tags: Set<AnyHashable>,
                                                constructor: @escaping Constructor<`Type`, repeat each Argument>) -> Registration {
        let registration = Registration(type: type, arguments: (repeat each Argument).self, tags: tags)
        let dependency = Dependency(registration: registration, scope: scope, constructor: constructor)
        
        Log.registry.notice("\(registration, privacy: .sensitive(mask: .hash)) Scope: \(scope.rawValue, privacy: .public)")
        commit(registration: registration, dependency: dependency)
        return registration
    }
    
    @discardableResult
    public func register<`Type`, each Argument>(_ type: `Type`.Type = `Type`.self,
                                                scope: Scope = .unique,
                                                tags: Set<AnyHashable>,
                                                constructor: @escaping AsyncConstructor<`Type`, repeat each Argument>) -> Registration {
        let registration = Registration(type: type, arguments: (repeat each Argument).self, tags: tags)
        let dependency = Dependency(registration: registration, scope: scope, constructor: constructor)
        
        Log.registry.notice("\(registration, privacy: .sensitive(mask: .hash)) Scope: \(scope.rawValue, privacy: .public)")
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
        queue.sync {
            var entries = filter(dependencies: dependencies, against: registration)
            if let parent {
                let parentRegs = parent.locate(registration)
                entries = parentRegs.merging(entries, uniquingKeysWith: { _, new in new })
            }
            
            guard entries.isEmpty else {
                return entries
            }
            
            var collaboratedEntries: [Registration: any Injectable] = [:]
            
            weakCollaborators.forEach { weakContainer in
                if let container = weakContainer.value {
                    let located = container.locate(registration)
                    collaboratedEntries = located.merging(collaboratedEntries, uniquingKeysWith: { current, _ in current })
                }
            }
            return collaboratedEntries
        }
    }
}
