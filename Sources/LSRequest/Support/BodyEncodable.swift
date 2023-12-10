//
//  BodyEncodable.swift
//
//
//  Created by czi on 2023/12/7.
//

import Foundation

public protocol BodyEncodable {
    func asData() -> Data?
}

public extension BodyEncodable where Self: Encodable {
    func asData() -> Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        return try? encoder.encode(self)
    }
}

//extension String: BodyEncodable {
//    public func asData() -> Data? {
//        data(using: .utf8)
//    }
//}
