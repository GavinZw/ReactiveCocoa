imports.extend(["AppKit"])

exported_targets.update({
	"NSControl": [
		("String", "stringValue"),
		("NSAttributedString", "attributedStringValue"),
		("Bool", "boolValue"),
		("Int32", "intValue"),
		("Int", "integerValue"),
		("Double", "doubleValue")
	]
})

default_signals.update({
	"NSTextField": ("String", "stringValues")
})
