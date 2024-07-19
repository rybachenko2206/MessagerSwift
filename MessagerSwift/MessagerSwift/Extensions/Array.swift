//
//  Array.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 19.07.24.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return index < count && index >= 0 ? self[index] : nil
    }
    
    func item(at index: Int) -> Element? {
      return indices.contains(index) ? self[index] : nil
    }
    
    mutating func removeItem(at index: Int) {
        guard index < self.count else { return }
        remove(at: index)
    }
    
    static func isNilOrEmpty(_ array: Array<Element>?) -> Bool {
        guard let arr = array, !arr.isEmpty else { return true }
        return false
    }
}

extension Array where Element == String? {
    /// For Array of optional strings will combine all values with " " as separator. Will return nil if all elements is nill or array is empty or all items is empty strings
    var spaceJoined: String? {
        return joinedBy()
    }
    
    func joinedBy(_ separator: String = " ") -> String? {
        let noNilArray = compactMap { $0 }.filter { !$0.isEmpty }
        if noNilArray.isEmpty { return nil }
        return noNilArray.joined(separator: separator)
    }
}

extension Array where Element == String {
    var spaceJoined: String { joined(separator: " ") }
}

extension Optional where Wrapped == Array<Any> {
    var isNilOrEmpty: Bool { Array.isNilOrEmpty(self)}
}
