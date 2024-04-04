//
//  RegistrationTests.swift
//  
//
//  Created by Karl Catigbe on 4/4/24.
//

import XCTest
@testable import Injector

final class RegistryTests: XCTestCase {

    var container: Container!
    
    override func setUpWithError() throws {
        container = Container()
    }

    override func tearDownWithError() throws {
        container = nil
    }

    func testRegistrationOfOneDependency() throws {
        container.register { _ in MockServiceImp1() as MockService}

        XCTAssertFalse(container.dependendencies.isEmpty)
        XCTAssertEqual(container.dependendencies.count, 1)
        let registration = Registration(type: MockService.self)
        XCTAssertNotNil(container.dependendencies[registration])
        
    }
    
    func testDoubleRegistrationOnlyRegistersOneInstance() throws {
        container.register { _ in MockServiceImp1() as MockService}
        container.register(MockService.self, instance: MockServiceImp1())
                        
        XCTAssertFalse(container.dependendencies.isEmpty)
        XCTAssertEqual(container.dependendencies.count, 1)
        let registration = Registration(type: MockService.self)
        XCTAssertNotNil(container.dependendencies[registration])
    }
}