//
//  ProxyWrapper.swift
//  GreedyKit
//
//  jegnux/ProxyPropertyWrapper.swift
//  Created by Igor Belov on 05.09.2022.
//

import Foundation

@propertyWrapper
public struct AnyProxy<EnclosingSelf, Value> {
    private let keyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>

    public init(_ keyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>) {
        self.keyPath = keyPath
    }

    // swiftlint:disable unused_setter_value
    @available(*, unavailable, message: "The wrapped value must be accessed from the enclosing instance property.")
    public var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }
    // swiftlint:enable unused_setter_value

    public static subscript(
        _enclosingInstance observed: EnclosingSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Self>
    ) -> Value {
        get {
            let storageValue = observed[keyPath: storageKeyPath]
            let value = observed[keyPath: storageValue.keyPath]
            return value
        }
        set {
            let storageValue = observed[keyPath: storageKeyPath]
            observed[keyPath: storageValue.keyPath] = newValue
        }
    }
}

extension NSObject: ProxyContainer {}

public protocol ProxyContainer {
    typealias Proxy<T> = AnyProxy<Self, T>
}
