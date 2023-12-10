//
//  ExecutorMacro.swift
//
//
//  Created by sandsn on 2023/12/9.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct ExecutorMacro: MemberMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        var hasGeneric = false
        var executerTypeName: String = "URLSession"
        if let actualGeneric = node.attributeName.as(IdentifierTypeSyntax.self)?.genericArgumentClause?.arguments.first?.description {
            executerTypeName = actualGeneric
            hasGeneric = true
        }
        
        // typealias
        let initializer = TypeInitializerClauseSyntax(value: IdentifierTypeSyntax(name: .identifier(executerTypeName)))
        let typealiasDecl = TypeAliasDeclSyntax(name: .identifier("ExecutorImpl"), initializer: initializer)
        // property
        let type = TypeAnnotationSyntax(type: IdentifierTypeSyntax(name: .identifier(executerTypeName)))
        let initSyntax = InitializerClauseSyntax(value: MemberAccessExprSyntax(declName: DeclReferenceExprSyntax(baseName: .identifier("shared"))))
        let variableDecl = VariableDeclSyntax(.let, name: PatternSyntax(stringLiteral: "executer"), type: type, initializer: hasGeneric ? nil : initSyntax).cast(DeclSyntax.self)

        return [DeclSyntax(typealiasDecl), DeclSyntax(variableDecl)]
    }
}
