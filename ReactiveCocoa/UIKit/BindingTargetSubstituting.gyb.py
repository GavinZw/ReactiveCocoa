imports.extend(["UIKit"])

exported_targets.update({
	"UIActivityIndicatorView": [("Bool", "isAnimating")],
	"UILabel": [("String?", "text"), ("NSAttributedString?", "attributedText")],
	"UITextField": [("String?", "text")],
	"UITextView": [("String", "text")],
	"UIProgressView": [("Float", "progress")],
	"UIImageView": [("UIImage", "image")],
	"UISegmentedControl": [("Int", "selectedSegmentIndex")]
})

default_signals.update({
	"UITextField": ("String?", "textValues"),
	"UITextView": ("String", "textValues"),
	"UISegmentedControl": ("Int", "selectedSegmentIndexes")
})

if target == "iOS":
	exported_targets.update({
		"UIDatePicker": [("Date", "date")],
		"UISwitch": [("Bool", "isOn")]
	})
	default_signals.update({
		"UIDatePicker": ("Date", "dates"),
		"UISwitch": ("Bool", "isOnValues")
	})
