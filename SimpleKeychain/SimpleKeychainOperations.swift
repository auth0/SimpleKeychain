import Security

typealias RetrieveFunction = (_ query: CFDictionary, _ result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
typealias RemoveFunction = (_ query: CFDictionary) -> OSStatus

class SimpleKeychainOperations: @unchecked Sendable {
    static var shared = SimpleKeychainOperations()

    var retrieve: RetrieveFunction = SecItemCopyMatching
    var remove: RemoveFunction = SecItemDelete
}
