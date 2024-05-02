//
//  CriteriaTests.swift
//
//  Copyright © 2024 Condemned.net.
//

@testable import Injector
import XCTest

final class CriteriaTests: XCTestCase {
    func testOperatorFullCriteriaRegistration() throws {
        let criteria = Criteria(MockServiceImp1.self, tags: .equals("mock", "test"), arguments: Void.self, scope: .singleton)
        let registration = Registration(type: MockServiceImp1.self, arguments: Void.self, tags: ["mock", "test"])
        XCTAssertTrue(criteria ~= registration)
    }

    func testOperatorNoTypeCriteriaRegistration() throws {
        let criteria = Criteria(tags: .equals("mock", "test"), arguments: Void.self)
        let registration = Registration(type: MockServiceImp1.self, arguments: Void.self, tags: ["mock", "test"])
        XCTAssertTrue(criteria ~= registration)
    }

    func testOperatorNoTagsCriteriaRegistration() throws {
        let criteria = Criteria(MockServiceImp1.self, arguments: Void.self)
        let registration = Registration(type: MockServiceImp1.self, arguments: Void.self, tags: ["mock", "test"])
        XCTAssertTrue(criteria ~= registration)
    }

    func testOperatorNoArgsCriteriaRegistration() throws {
        let criteria = Criteria(MockServiceImp1.self)
        let registration = Registration(type: MockServiceImp1.self, arguments: Void.self, tags: ["mock", "test"])
        XCTAssertTrue(criteria ~= registration)
    }

    func testOperatorJustTagsCriteriaRegistration() throws {
        let criteria = Criteria(tags: .contains("test"))
        let registration = Registration(type: MockServiceImp1.self, arguments: Void.self, tags: ["mock", "test"])
        XCTAssertTrue(criteria ~= registration)
    }

    func testOperatorScopedCriteriaInjectable() throws {
        class FakeInjectable: Injectable {
            var scope: Injector.Scope = .singleton

            func resolve(_: any Injector.Resolver, arguments _: Any) throws -> Any {
                throw MockError.testError
            }
        }

        let criteria = Criteria(MockServiceImp1.self, tags: .equals("mock", "test"), arguments: Void.self, scope: .singleton)
        let injectable = FakeInjectable()
        XCTAssertTrue(criteria ~= injectable)
    }

    func testOperatorNoScopeCriteriaInjectable() throws {
        class FakeInjectable: Injectable {
            var scope: Injector.Scope = .singleton

            func resolve(_: any Injector.Resolver, arguments _: Any) throws -> Any {
                throw MockError.testError
            }
        }

        let criteria = Criteria(MockServiceImp1.self, tags: .equals("mock", "test"), arguments: Void.self)
        let injectable = FakeInjectable()
        XCTAssertTrue(criteria ~= injectable)
    }

    func testOperatorCriteriaDictionary() throws {
        class FakeInjectable: Injectable {
            var scope: Injector.Scope = .singleton

            func resolve(_: any Injector.Resolver, arguments _: Any) throws -> Any {
                throw MockError.testError
            }
        }

        let criteria = Criteria(MockServiceImp1.self, tags: .equals("mock", "test"), arguments: Void.self)
        let injectable = FakeInjectable()
        let registration = Registration(type: MockServiceImp1.self, arguments: Void.self, tags: ["mock", "test"])

        let dict = [registration: injectable]

        XCTAssertTrue(criteria ~= dict.first!)
    }
}
