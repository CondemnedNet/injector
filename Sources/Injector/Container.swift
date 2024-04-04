import Foundation

public enum Scope {
    case unique
    case singleton
}

public typealias Constructor<`Type`, each Argument> = (any Resolver, repeat each Argument) throws -> `Type`

public class Container {
    
    internal private(set) var dependendencies: [Registration: any Injectable] = [:]
    private let queue: DispatchQueue = DispatchQueue(label: "container", attributes: .concurrent)
    
}

extension Container: Registry {
    // MARK: Register Dependencies
    @discardableResult
    public func register<`Type`, each Argument>(_ type: `Type`.Type = `Type`.self,
                                                scope: Scope = .unique,
                                                tags: Set<AnyHashable>,
                                                constructor: @escaping Constructor<`Type`, repeat each Argument>)  -> Registration {
        
        let registration = Registration(type: type, arguments: (repeat each Argument).self, tags: tags)
        let dependency = Dependency(registration: registration, scope: scope, constructor: constructor)
        commit(registration: registration, dependency: dependency)
        return registration
    }
    
    private func commit(registration: Registration, dependency: any Injectable) {
        queue.sync(flags: .barrier) {
            dependendencies[registration] = dependency
        }
        
    }
}

extension Container: Resolver { }

extension Container: Locator {
    public func locate(_ criteria: Criteria) -> [Registration : any Injectable] {
        queue.sync {
            return dependendencies.filter { criteria ~= $0 }
        }
    }
}
