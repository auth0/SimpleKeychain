public struct SimpleKeychainAttributes: @unchecked Sendable{
    private let storage: [String: Any]

    public init(_ attributes: [String: Any]) {
        self.storage = attributes
    }

    public var asDictionary: [String: Any] {
        return storage
    }

    public subscript(key: String) -> Any? {
        return storage[key]
    }

    public var isEmpty: Bool {
        return storage.isEmpty
    }

    public var count: Int {
        return storage.count
    }
}
