//
//  File.swift
//  
//
//  Created by czi on 2023/12/8.
//

import Foundation

public protocol Parser {
    associatedtype Payload
    func parse(_ data: Data) throws -> Payload
}

extension Parser where Payload: Decodable {
    public func parse(_ data: Data) throws -> Payload {
        try JSONDecoder().decode(Payload.self, from: data)
    }
}

extension Parser where Payload == Void {
    public func parse(_ data: Data) throws -> Payload {
        ()
    }
}

public struct SimpleParser<Payload: Decodable>: Parser {
    public init(){}
}

public struct VoidParser: Parser {
    public typealias Payload = Void
    
    public init(){}
}
