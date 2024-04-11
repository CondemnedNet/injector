//
//  RegistrationTests.swift
//
//
//  Created by Karl Catigbe on 4/4/24.
//

@testable import Injector
import XCTest

final class RegistryTests: XCTestCase {
    var container: Container!
    
    override func setUpWithError() throws {
        container = Container()
    }

    override func tearDownWithError() throws {
        container = nil
    }

    func testRegistrationOfOneDependency() throws {
        container.register { _ in MockServiceImp1() as MockService }

        XCTAssertFalse(container.dependencies.isEmpty)
        XCTAssertEqual(container.dependencies.count, 1)
        let registration = Registration(type: MockService.self)
        XCTAssertNotNil(container.dependencies[registration])
    }
    
    func testDoubleRegistrationOnlyRegistersOneInstance() throws {
        container.register { _ in MockServiceImp1() as MockService }
        container.register(MockService.self, instance: MockServiceImp1())
                        
        XCTAssertFalse(container.dependencies.isEmpty)
        XCTAssertEqual(container.dependencies.count, 1)
        let registration = Registration(type: MockService.self)
        XCTAssertNotNil(container.dependencies[registration])
    }
}
