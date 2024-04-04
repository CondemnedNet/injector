import Foundation

public enum Scope {
    case unique
    case singleton
}

public typealias Constructor<`Type`, each Argument> = (any Registry, repeat each Argument) throws -> `Type`

public class Container: Registry {
    
    
    private var dependendencies: [Registration: any Injectable] = [:]
    private let queue: DispatchQueue = DispatchQueue(label: "container", attributes: .concurrent)
    
    // MARK: Register Dependencies
    @discardableResult
    public func register<`Type`, each Argument>(_ type: `Type`.Type,
                                                scope: Scope = .unique,
                                                tags: Set<AnyHashable> = [],
                                                constructor: @escaping Constructor<`Type`, repeat each Argument>)  -> Registration {
        
        let registration = Registration(type: `Type`.self, arguments: (repeat each Argument).self, tags: tags)
        let dependency = Dependency(registration: registration, constructor: constructor)
        commit(registration: registration, dependency: dependency)
        return registration
    }
    
    
    @discardableResult
    public func register<`Type`, each Argument>(_ type: `Type`.Type,
                                                scope: Scope = .unique,
                                                tags: AnyHashable...,
                                                constructor: @escaping Constructor<`Type`, repeat each Argument>)  -> Registration {
        return register(type, scope: scope, tags: Set(tags), constructor: constructor)
        
    }
    
    func commit(registration: Registration, dependency: any Injectable) {
        queue.sync(flags: .barrier) {
            dependendencies[registration] = dependency
        }
        
    }
}
