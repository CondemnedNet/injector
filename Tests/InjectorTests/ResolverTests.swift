//
//  ResolverTests.swift
//
//
//  Created by Karl Catigbe on 4/4/24.
//

@testable import Injector
import XCTest

final class ResolverTests: XCTestCase {
    var container: Container!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        container = Container()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        container = nil
    }

    func testResolveReturnsCapturedInstance() throws {
        let concrete = MockServiceImp1()
        let implemented: MockService = MockServiceImp1()
        
        container.register { _ in implemented }
        container.register(instance: concrete)
        
        let resolvedImpl = try container.resolve() as MockService
        let resolvedConc = try container.resolve(MockServiceImp1.self)
        XCTAssertTrue(resolvedImpl === implemented)
        XCTAssertTrue(resolvedConc === concrete)
    }

    func testResolveSingletonReturnsSameInstance() throws {
        container.register(scope: .singleton) { _ in
            MockServiceImp1()
        }
        
        let firstResolved = try container.resolve() as MockServiceImp1
        let secondResolved = try container.resolve(MockServiceImp1.self)
        
        XCTAssertTrue(firstResolved === secondResolved)
    }
    
    func testThrowingRandomErrorThrowsInjectionError() throws {
        container.register { _ in
            try ThrowingMockService(error: MockError.testError) as MockService
        }
            
        XCTAssertThrowsError(try container.resolve() as MockService) {
            if case let .other(error) = $0 as? InjectorError, let mockError = error as? MockError {
                XCTAssertEqual(mockError, MockError.testError)
            } else {
                XCTFail("Got the wrong error! \($0)")
            }
        }
    }
    
    func testThrowingInjectionErrorThrowsInjectionError() throws {
        let registration = Registration(type: Int.self)
        container.register { _ in
            try ThrowingMockService(error: InjectorError.notFound(registration)) as MockService
        }
            
        XCTAssertThrowsError(try container.resolve() as MockService) {
            if case let .notFound(reg) = $0 as? InjectorError {
                XCTAssertEqual(registration, reg)
            } else {
                XCTFail("Got the wrong error! \($0)")
            }
        }
    }
}
