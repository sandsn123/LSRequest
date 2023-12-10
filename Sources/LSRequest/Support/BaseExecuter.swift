//
//  File.swift
//  
//
//  Created by czi on 2023/12/8.
//

import Foundation
public protocol Executor {
    func execute(_ request: URLRequest) async throws -> (Data, HTTPURLResponse)
}
