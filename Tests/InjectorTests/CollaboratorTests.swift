//
//  CollaboratorTests.swift
//  
//
//  Created by Karl Catigbe on 4/10/24.
//

import XCTest
@testable import Injector

final class CollaboratorTests: XCTestCase {

    var container: Container!
    var parent: Container!
    var collaborator: Container!
    
    override func setUpWithError() throws {
        parent = Container()
        container = Container(parent: parent)
        collaborator = Container()
    }

    override func tearDownWithError() throws {
        parent = nil
        container = nil
        collaborator = nil
    }

    func testAddingCollaborator() throws {
        container.collaborate(with: collaborator)
        XCTAssertFalse(container.collaborators.isEmpty)
        XCTAssertEqual(container.collaborators.count, 1)
    }
    
    func testNilingCollaboratorDoesNotRetain() throws {
        var tempCollab: Container? = Container()
        
        tempCollab?.register { _ in
            MockServiceImp1("weak!") as MockService
        }
        
        container.collaborate(with: tempCollab!)
        XCTAssertFalse(container.collaborators.isEmpty)
        XCTAssertEqual(container.collaborators.count, 1)
        
        tempCollab = nil
        
        XCTAssertTrue(container.collaborators.isEmpty)
        XCTAssertEqual(container.collaborators.count, 0)
        
        XCTAssertNil(container.collaborators.first)
        
    }
    
    func testResolvingFromCollaboratorGetsMainInstance() throws {
        let mainInstance: MockService = MockServiceImp1()
        container.register { _ in
            mainInstance
        }
        
        let collabInstance: MockService = MockServiceImp1()
        collaborator.register { _ in
            collabInstance
        }
        
        container.collaborate(with: collaborator)
        
        let resolved = try container.resolve() as MockService
        XCTAssertIdentical(mainInstance, resolved)
    }
    
    func testResolvingFromCollaboratorGetsParentInstance() throws {
        let parentInstance: MockService = MockServiceImp1("parent")
        parent.register { _ in
            parentInstance
        }
        
        let collabInstance: MockService = MockServiceImp1("collab")
        collaborator.register { _ in
            collabInstance
        }
        
        container.collaborate(with: collaborator)
        
        let resolved = try container.resolve() as MockService
        XCTAssertIdentical(parentInstance, resolved)
        XCTAssertEqual(resolved.string, parentInstance.string)
    }
    
    func testMultipleCollaboratorsResolvesLastCollaborator() throws {
        let mainInstance = MockServiceImp1("main")
        container.register { _ in
            mainInstance
        }
        
        let parentInstance = MockServiceImp1("parent")
        parent.register { _ in
            parentInstance
        }
        
        let collabInstance: MockService = MockServiceImp1("collab")
        collaborator.register { _ in
            collabInstance
        }
        
        let localInstances = ["local1", "local2", "local3", "local4"].map({ return  MockServiceImp1($0) as MockService })
        
        let collaborators = localInstances.map({
            let collab = Container()
            collab.register(instance: $0)
            return collab
        })
        
        container.collaborate(with: collaborators)
        
        let resolved = try container.resolve() as MockService
        XCTAssertIdentical(resolved, localInstances[3])
        XCTAssertEqual(resolved.string, localInstances[3].string)
                      
    }
    
    func testMultipleCollaboratorsResolvesTaggedCollaborator() throws {
        let mainInstance = MockServiceImp1("main")
        container.register { _ in
            mainInstance
        }
        
        let parentInstance = MockServiceImp1("parent")
        parent.register { _ in
            parentInstance
        }
        
        let collabInstance: MockService = MockServiceImp1("collab")
        collaborator.register { _ in
            collabInstance
        }
        
        let localInstances = ["local1", "local2", "local3", "local4"].map({ return  MockServiceImp1($0) as MockService })
        
        let collaborators = localInstances.map({
            let collab = Container()
            collab.register(tags: $0.string, instance: $0)
            return collab
        })
        
        container.collaborate(with: collaborators)
        
        let resolved = try container.resolve(tags: "local3") as MockService
        XCTAssertIdentical(resolved, localInstances[2])
        XCTAssertEqual(resolved.string, localInstances[2].string)
                      
    }
    
    func testAddingIncompatibleCollaboratorDoesntAdd() throws {
        container.collaborate(with: BadCollaborator())
        XCTAssertTrue(container.collaborators.isEmpty)
        XCTAssertEqual(container.collaborators.count, 0)
        XCTAssertNil(container.collaborators.first)
    }
}
