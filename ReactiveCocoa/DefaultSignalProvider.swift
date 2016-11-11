import ReactiveSwift
import enum Result.NoError

public protocol DefaultSignalProvider {
	associatedtype DefaultSignalValue

	var defaultSignal: Signal<DefaultSignalValue, NoError> { get }
}

extension BindingTargetProtocol {
	public static func <~ <Provider: DefaultSignalProvider>(target: Self, provider: Provider) -> Disposable? where Value == Provider.DefaultSignalValue {
		return target <~ provider.defaultSignal
	}
}

extension BindingTargetProtocol where Value: OptionalProtocol {
	public static func <~ <Provider: DefaultSignalProvider>(target: Self, provider: Provider) -> Disposable? where Value.Wrapped == Provider.DefaultSignalValue {
		return target <~ provider.defaultSignal
	}
}
