//
//  File.swift
//  
//
//  Created by czi on 2023/12/8.
//

import Foundation

public protocol Service {
    associatedtype ExecutorImpl: Executor = URLSession
    associatedtype RequestImpl: Request
    associatedtype ParserImpl: Parser

    var request: RequestImpl { get }
    var executer: ExecutorImpl { get }
    var parser: ParserImpl { get }

    func request() async throws -> ParserImpl.Payload
}

public extension Service where ExecutorImpl: URLSession {
    var executer: URLSession {
        URLSession.shared
    }
}

public extension Service {
    func request() async throws -> ParserImpl.Payload {
        let urlRequest = try request.asURLRequest()
        let (data, response) = try await executer.execute(urlRequest)
        guard (200..<300).contains(response.statusCode) else {
            throw LSResponseError.wrongResponse(response)
        }
        return try parser.parse(data)
    }
}

enum LSResponseError: Error {
    case wrongResponse(HTTPURLResponse)
}
