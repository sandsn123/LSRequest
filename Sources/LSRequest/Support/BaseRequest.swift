//
//  File.swift
//  
//
//  Created by czi on 2023/12/4.
//

import Foundation

public protocol Request {
    func asURLRequest() throws -> URLRequest
}

public extension Request {
    var headers: HTTPHeaders {
        var headers = HTTPHeaders.default
        headers.add(.contentType("application/json;charset=UTF-8"))
        return headers
    }
}

public extension LSRequest.Request {
    var domain: String {
        fatalError("please rewrite your domain in your project!!")
    }
}
