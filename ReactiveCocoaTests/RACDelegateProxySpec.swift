@testable import ReactiveCocoa
import Quick
import Nimble

@objc protocol TestProtocol {
	func req1()
	@objc optional func req2()
	@objc optional func req3() -> Int
}

class TestDelegate: TestProtocol {
	var req1Counter = 0

	func req1() {
		req1Counter += 1
	}
}

class TestDelegate2: TestProtocol {
	var req1Counter = 0
	var req2Counter = 0

	func req1() {
		req1Counter += 1
	}

	func req2() {
		req2Counter += 1
	}
}

class TestDelegator: NSObject {
	dynamic weak var delegate: TestProtocol?
}

class RACDelegateProxySpec: QuickSpec {
	override func spec() {
		describe("RACDelegateProxy") {
			var delegator: TestDelegator!
			var proxy: RACDelegateProxy!
			weak var _delegator: TestDelegator?

			var skipsRetainCycleCheck = false

			beforeEach {
				skipsRetainCycleCheck = false

				delegator = TestDelegator()
				_delegator = delegator
				proxy = delegator._rac_delegateProxy(for: #selector(setter: delegator.delegate),
				                                     with: TestProtocol.self)
			}

			afterEach {
				if skipsRetainCycleCheck {
					return
				}

				delegator = nil
				expect(_delegator).to(beNil())
			}

			it("should return the same proxy") {
				let proxy2 = delegator._rac_delegateProxy(for: #selector(setter: delegator.delegate),
				                                         with: TestProtocol.self)
				expect(proxy).to(beIdenticalTo(proxy2))
			}

			it("should have swizzled the setter") {
				expect(delegator.delegate).to(beIdenticalTo(proxy))

				delegator.delegate = nil
				expect(delegator.delegate).to(beIdenticalTo(proxy))
			}

			it("should respond to all requirements except the optional requirements with non-void return type") {
				expect(proxy.conforms(to: TestProtocol.self)) == true
				expect(proxy.responds(to: #selector(TestProtocol.req1))) == true
				expect(proxy.responds(to: #selector(TestProtocol.req2))) == true
				expect(proxy.responds(to: #selector(TestProtocol.req3))) == false
			}

			it("should emit events for mandatory requirements") {
				var counter = 0

				proxy.reactive
					.trigger(for: #selector(TestProtocol.req1))
					.observeValues { counter += 1 }

				expect(counter) == 0

				delegator.delegate?.req1()
				expect(counter) == 1
			}

			it("should emit events for optional requirements with void as return type") {
				var counter = 0

				proxy.reactive
					.trigger(for: #selector(TestProtocol.req2))
					.observeValues { counter += 1 }

				expect(counter) == 0

				delegator.delegate?.req2!()
				expect(counter) == 1
			}

			it("should emit events for optional requirements with non-void return type") {
				var counter = 0

				proxy.reactive
					.trigger(for: #selector(TestProtocol.req3))
					.observeValues { counter += 1 }

				expect(counter) == 0

				expect { delegator.delegate?.req3!() }.to(raiseException())
				expect(counter) == 0

				skipsRetainCycleCheck = true
			}
		}
	}
}
