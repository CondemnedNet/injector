import Foundation

public enum Scope {
    case unique
    case singleton
}

public class Container {
    internal private(set) var parent: Container?
    internal private(set) var dependencies: [Registration: any Injectable] = [:]
    private let queue = DispatchQueue(label: "container", attributes: .concurrent)
    
    init(parent: Container? = nil) {
        self.parent = parent
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
            if let parent {
                let parentRegs = parent.locate(registration)
                let entries = filter(dependencies: dependencies, against: registration)
                return parentRegs.merging(entries, uniquingKeysWith: { $1 })
            }
            return filter(dependencies: dependencies, against: registration)
        }
    }
}
