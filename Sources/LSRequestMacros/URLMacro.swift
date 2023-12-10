//
//  File.swift
//  
//
//  Created by czi on 2023/12/6.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

enum URLMacroError: CustomStringConvertible, Error {
    case message(String)
    case malformedURL(String)
    
    var description: String {
        switch self {
        case .message(let string):
            return string
        case .malformedURL(let urlString):
            return "The input URL is malformed: \(urlString)"
        }
    }
}

public struct URLMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        
        let arguments = node.argumentList
        guard let path = arguments.first?.expression.description else {
            throw URLMacroError.message("#URL requires a static string literal")
        }
        guard let _ = URL(string: path) else {
            throw URLMacroError.malformedURL("\(path)")
        }
        
        if arguments.count == 2, let domain = arguments.last?.expression.description {
            guard let _ = URL(string: path, relativeTo: URL(string: domain)!) else {
                throw URLMacroError.malformedURL("\(domain)" + "\(path)")
            }
            return "URL(string: \(raw: path), relativeTo: URL(string: \(raw: domain))!)!"
        } else {
            return "URL(string: \(raw: path))!"
        }
        
    }
}
