//
//  ParentRegistryTests.swift
//
//
//  Created by Karl Catigbe on 4/10/24.
//

@testable import Injector
import XCTest

final class ParentResolverTests: XCTestCase {
    var container: Container!
    var parentContainer: Container!
    
    override func setUpWithError() throws {
        parentContainer = Container()
        container = Container(parent: parentContainer)
    }

    override func tearDownWithError() throws {
        container = nil
    }

    func testResolveReturnsInstanceFromParent() throws {
        let childImpl = MockServiceImp1()
        let parentImpl: MockService = MockServiceImp1()
        
        parentContainer.register { _ in parentImpl }
        container.register(instance: childImpl)
        
        let resolvedParent = try container.resolve() as MockService
        let resolvedChild = try container.resolve(MockServiceImp1.self)
        XCTAssertTrue(resolvedParent === parentImpl)
        XCTAssertTrue(resolvedChild === childImpl)
    }

    func testChildImplOverridesParentImpl() throws {
        let childImpl = MockServiceImp1(string: "Child")
        let parentImpl = MockServiceImp1(string: "Parent")
        
        parentContainer.register { _ in parentImpl }
        container.register(instance: childImpl)
        
        let resolvedParent = try container.resolve() as MockServiceImp1
        let resolvedChild = try container.resolve(MockServiceImp1.self)
        XCTAssertTrue(resolvedParent === resolvedChild)
        XCTAssertTrue(resolvedChild === childImpl)
    }
}
