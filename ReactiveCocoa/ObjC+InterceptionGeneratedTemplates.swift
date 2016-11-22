extension InterceptionTemplates {
	internal static func setup() -> [String: Template] {
		return [
			"v@:": _v0_id_sel,
			"v@:c": _v0_id_sel_i8,
			"v@:l": _v0_id_sel_i32,
			"v@:q": _v0_id_sel_i64,
			"v@:@q": _v0_id_sel_id_i64,
			"v@:@l": _v0_id_sel_id_i32,
			"v@:@d": _v0_id_sel_id_f64,
			"v@:@f": _v0_id_sel_id_f32,
			"v@:@@": _v0_id_sel_id_id,
			"v@:@@q": _v0_id_sel_id_id_i64,
			"v@:@@@": _v0_id_sel_id_id_id,
		]
	}
}

private let _v0_id_sel: InterceptionTemplates.Template = { perceivedClass, realClass, selector in
		let impl: @convention(block) (NSObject) -> Void = { object in
		typealias CImpl = @convention(c) (NSObject, Selector) -> Void
		_rac_interception_template(object, perceivedClass, realClass, selector,
		                           { unsafeBitCast($0, to: CImpl.self)(object, selector) },
		                           { [] })
	}
	return imp_implementationWithBlock(impl as Any)
}
private let _v0_id_sel_i8: InterceptionTemplates.Template = { perceivedClass, realClass, selector in
		let impl: @convention(block) (NSObject, CChar) -> Void = { object, a in
		typealias CImpl = @convention(c) (NSObject, Selector, CChar) -> Void
		_rac_interception_template(object, perceivedClass, realClass, selector,
		                           { unsafeBitCast($0, to: CImpl.self)(object, selector, a) },
		                           { [a] })
	}
	return imp_implementationWithBlock(impl as Any)
}
private let _v0_id_sel_i32: InterceptionTemplates.Template = { perceivedClass, realClass, selector in
		let impl: @convention(block) (NSObject, CLong) -> Void = { object, a in
		typealias CImpl = @convention(c) (NSObject, Selector, CLong) -> Void
		_rac_interception_template(object, perceivedClass, realClass, selector,
		                           { unsafeBitCast($0, to: CImpl.self)(object, selector, a) },
		                           { [a] })
	}
	return imp_implementationWithBlock(impl as Any)
}
private let _v0_id_sel_i64: InterceptionTemplates.Template = { perceivedClass, realClass, selector in
		let impl: @convention(block) (NSObject, CLongLong) -> Void = { object, a in
		typealias CImpl = @convention(c) (NSObject, Selector, CLongLong) -> Void
		_rac_interception_template(object, perceivedClass, realClass, selector,
		                           { unsafeBitCast($0, to: CImpl.self)(object, selector, a) },
		                           { [a] })
	}
	return imp_implementationWithBlock(impl as Any)
}
private let _v0_id_sel_id_i64: InterceptionTemplates.Template = { perceivedClass, realClass, selector in
		let impl: @convention(block) (NSObject, AnyObject?, CLongLong) -> Void = { object, a, b in
		typealias CImpl = @convention(c) (NSObject, Selector, AnyObject?, CLongLong) -> Void
		_rac_interception_template(object, perceivedClass, realClass, selector,
		                           { unsafeBitCast($0, to: CImpl.self)(object, selector, a, b) },
		                           { [a, b] })
	}
	return imp_implementationWithBlock(impl as Any)
}
private let _v0_id_sel_id_i32: InterceptionTemplates.Template = { perceivedClass, realClass, selector in
		let impl: @convention(block) (NSObject, AnyObject?, CLong) -> Void = { object, a, b in
		typealias CImpl = @convention(c) (NSObject, Selector, AnyObject?, CLong) -> Void
		_rac_interception_template(object, perceivedClass, realClass, selector,
		                           { unsafeBitCast($0, to: CImpl.self)(object, selector, a, b) },
		                           { [a, b] })
	}
	return imp_implementationWithBlock(impl as Any)
}
private let _v0_id_sel_id_f64: InterceptionTemplates.Template = { perceivedClass, realClass, selector in
		let impl: @convention(block) (NSObject, AnyObject?, CDouble) -> Void = { object, a, b in
		typealias CImpl = @convention(c) (NSObject, Selector, AnyObject?, CDouble) -> Void
		_rac_interception_template(object, perceivedClass, realClass, selector,
		                           { unsafeBitCast($0, to: CImpl.self)(object, selector, a, b) },
		                           { [a, b] })
	}
	return imp_implementationWithBlock(impl as Any)
}
private let _v0_id_sel_id_f32: InterceptionTemplates.Template = { perceivedClass, realClass, selector in
		let impl: @convention(block) (NSObject, AnyObject?, CFloat) -> Void = { object, a, b in
		typealias CImpl = @convention(c) (NSObject, Selector, AnyObject?, CFloat) -> Void
		_rac_interception_template(object, perceivedClass, realClass, selector,
		                           { unsafeBitCast($0, to: CImpl.self)(object, selector, a, b) },
		                           { [a, b] })
	}
	return imp_implementationWithBlock(impl as Any)
}
private let _v0_id_sel_id_id: InterceptionTemplates.Template = { perceivedClass, realClass, selector in
		let impl: @convention(block) (NSObject, AnyObject?, AnyObject?) -> Void = { object, a, b in
		typealias CImpl = @convention(c) (NSObject, Selector, AnyObject?, AnyObject?) -> Void
		_rac_interception_template(object, perceivedClass, realClass, selector,
		                           { unsafeBitCast($0, to: CImpl.self)(object, selector, a, b) },
		                           { [a, b] })
	}
	return imp_implementationWithBlock(impl as Any)
}
private let _v0_id_sel_id_id_i64: InterceptionTemplates.Template = { perceivedClass, realClass, selector in
		let impl: @convention(block) (NSObject, AnyObject?, AnyObject?, CLongLong) -> Void = { object, a, b, c in
		typealias CImpl = @convention(c) (NSObject, Selector, AnyObject?, AnyObject?, CLongLong) -> Void
		_rac_interception_template(object, perceivedClass, realClass, selector,
		                           { unsafeBitCast($0, to: CImpl.self)(object, selector, a, b, c) },
		                           { [a, b, c] })
	}
	return imp_implementationWithBlock(impl as Any)
}
private let _v0_id_sel_id_id_id: InterceptionTemplates.Template = { perceivedClass, realClass, selector in
		let impl: @convention(block) (NSObject, AnyObject?, AnyObject?, AnyObject?) -> Void = { object, a, b, c in
		typealias CImpl = @convention(c) (NSObject, Selector, AnyObject?, AnyObject?, AnyObject?) -> Void
		_rac_interception_template(object, perceivedClass, realClass, selector,
		                           { unsafeBitCast($0, to: CImpl.self)(object, selector, a, b, c) },
		                           { [a, b, c] })
	}
	return imp_implementationWithBlock(impl as Any)
}
