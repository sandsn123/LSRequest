//
//  File.swift
//  
//
//  Created by czi on 2023/12/4.
//

import Foundation

public protocol Queryable {
    func asQuerys() -> [URLQueryItem]
}

public extension Queryable {
    func asQuerys() -> [URLQueryItem] {
        let properties = Mirror(reflecting: self)
        guard !properties.children.isEmpty else {
            return []
        }

        let querys = properties.children.reduce(into: [URLQueryItem]()) { previous, next in
            if let label = next.label {
                let item = URLQueryItem(name: label, value: "\(next.value)")
                previous.append(item)
            }
        }
        return querys
    }
}
