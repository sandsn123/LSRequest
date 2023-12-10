//
//  HeaderFieldMacro.swift
//
//
//  Created by czi on 2023/12/6.
//

import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics
import Foundation

public struct HeaderFieldMacro: MemberMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        
        if let dictString = node.arguments?.as(LabeledExprListSyntax.self)?.first?.expression.description {
            let decl =  try VariableDeclSyntax("var headers: HTTPHeaders") {
                if let dict = dictString.asDictionary() {
                    """
                        HTTPHeaders(\(raw: dict))
                    """
                }
            }
            return [DeclSyntax(decl)]
        } else {
            return []
        }
    }
}

extension String {
    func asDictionary() -> [String: String]? {
        if let data = data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
        }
        return nil
    }
}
