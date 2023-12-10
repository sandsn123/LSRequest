//
//  PayloadMacro.swift
//
//
//  Created by czi on 2023/12/8.
//

import Foundation
import Foundation
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder

enum PayloadMacroError: CustomStringConvertible, Error {
    case genericArgumentEmpty
    
    var description: String {
        switch self {
        case .genericArgumentEmpty:
            return "@Payload must have a generics type"
        }
    }
}

public struct PayloadMacro: MemberMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {

        guard let generic = node.attributeName.as(IdentifierTypeSyntax.self)?.genericArgumentClause else {
            return []
        }
        
        // typealias
        let simpleParserType = IdentifierTypeSyntax(name: .identifier("SimpleParser"), genericArgumentClause: generic)
        let parserInitializer = TypeInitializerClauseSyntax(value: simpleParserType)
        let typealiasDecl = TypeAliasDeclSyntax(modifiers: declaration.modifiers, name: .identifier("ParserImpl"), initializer: parserInitializer).cast(DeclSyntax.self)
        
        // property
        let parseType = TypeAnnotationSyntax(type: simpleParserType)
        let accessExpr = MemberAccessExprSyntax(declName: DeclReferenceExprSyntax(baseName: .keyword(.`init`)))
        let initializer = FunctionCallExprSyntax(callee: accessExpr)
        let parserValueDecl = VariableDeclSyntax(modifiers: declaration.modifiers, .let, name: PatternSyntax(stringLiteral: "parser"), type: parseType, initializer: InitializerClauseSyntax(value: initializer)).cast(DeclSyntax.self)

        return [typealiasDecl,parserValueDecl]
    }
}
