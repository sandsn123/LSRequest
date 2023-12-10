//
//  HTTPBodyMacro.swift
//
//
//  Created by czi on 2023/12/5.
//

import SwiftSyntax
import SwiftSyntaxMacros

enum HTTPBodyMacroError: CustomStringConvertible, Error {
    case mustAddMethodMacroAtSameTime
    case onlyApplicableToStruct
    var description: String {
        switch self {
        case .mustAddMethodMacroAtSameTime:
            return "@HTTPBody must add method macro at same time"
        case .onlyApplicableToStruct:
            return "@HTTPBody can only be applied to a struct"
        }
    }
}

/// HTTPBodyMacro
public struct HTTPBodyMacro: PeerMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw HTTPBodyMacroError.onlyApplicableToStruct
        }
        let attributeNames = structDecl.attributes.compactMap { $0.as(AttributeSyntax.self)?.attributeName.as(IdentifierTypeSyntax.self) }
        let macros = attributeNames.compactMap { $0.name.text }
        let methods = ["GET", "POST", "PUT", "DELETE", "PATCH", "HEAD"]
        guard macros.contains(where: {
            methods.contains($0)
        }) else {
            throw HTTPBodyMacroError.mustAddMethodMacroAtSameTime
        }
        return []
    }
}
