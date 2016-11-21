internal class InterceptionTemplates {
	internal typealias Template = (_ perceived: AnyClass, _ real: AnyClass, _ selector: Selector) -> IMP

	private static let shared = setup()

	private static func setup() -> [String: Template] {
		return [
			"v@:": invokeVoidVoid,
			"v@:q": invokeVoidInt
		]
	}

	static func template(forTypeEncoding types: UnsafePointer<Int8>) -> Template? {
		var iterator = types
		var characters = [UInt8]()

		let nul = Int8(UInt8(ascii: "\0"))
		let zero = Int8(UInt8(ascii: "0"))
		let nine = Int8(UInt8(ascii: "9"))

		while iterator.pointee != nul {
			characters.append(UInt8(iterator.pointee))
			iterator = NSGetSizeAndAlignment(iterator, nil, nil)
			while !(iterator.pointee < zero || iterator.pointee > nine) {
				iterator += 1
			}
		}

		let cleanEncoding = String(bytes: characters, encoding: .ascii)!
		return shared[cleanEncoding]
	}
}

private let invokeVoidInt: (AnyClass, AnyClass, Selector) -> IMP = { perceivedClass, realClass, selector in
	let impl: @convention(block) (NSObject, Int) -> Void = { object, first in
		typealias CImpl = @convention(c) (NSObject, Selector, Int) -> Void
		template(object, perceivedClass, realClass, selector,
		         { unsafeBitCast($0, to: CImpl.self)(object, selector, first) },
		         { [first] })
	}
	return imp_implementationWithBlock(impl as Any)
}

private let invokeVoidVoid: (AnyClass, AnyClass, Selector) -> IMP = { perceivedClass, realClass, selector in
	let impl: @convention(block) (NSObject) -> Void = { object in
		typealias CImpl = @convention(c) (NSObject, Selector) -> Void
		template(object, perceivedClass, realClass, selector,
		         { unsafeBitCast($0, to: CImpl.self)(object, selector) },
		         { [] })
	}
	return imp_implementationWithBlock(impl as Any)
}

private func template(_ object: NSObject, _ perceivedClass: AnyClass, _ realClass: AnyClass, _ selector: Selector, _ invoke: (IMP) -> Void, _ packer: () -> [Any?]) {
	let alias = selector.alias
	let interopAlias = selector.interopAlias

	defer {
		if let state = object.value(forAssociatedKey: alias.utf8Start) as! InterceptingState? {
			state.send(packIfNeeded: packer)
		}
	}

	let method = class_getInstanceMethod(perceivedClass, selector)!

	if class_respondsToSelector(realClass, interopAlias) {
		let interopImpl = class_getMethodImplementation(realClass, interopAlias)!
		invoke(interopImpl)
		return
	}

	if let impl = method_getImplementation(method), impl != _rac_objc_msgForward {
		invoke(impl)
		return
	}

	object.doesNotRecognizeSelector(selector)
}
