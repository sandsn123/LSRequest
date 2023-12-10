//
//  File.swift
//  
//
//  Created by czi on 2023/12/4.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder

enum QueryMacroError: CustomStringConvertible, Error {
    case onlyApplicableToVariable
    case onlyApplicableToStruct
    
    var description: String {
        switch self {
        case .onlyApplicableToStruct: return "@Query can only be applied to a struct"
        case .onlyApplicableToVariable: return "@QueryIgnore can only be applied to a single variable"
        }
    }
}

public struct QueryableMacro: ExtensionMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, attachedTo declaration: some SwiftSyntax.DeclGroupSyntax, providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol, conformingTo protocols: [SwiftSyntax.TypeSyntax], in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.ExtensionDeclSyntax] {

        let inheritanceClause = InheritanceClauseSyntax(inheritedTypesBuilder: {
              InheritedTypeSyntax(type: IdentifierTypeSyntax(name: "Queryable"))
            })
        
        let queryExtension = try ExtensionDeclSyntax(extendedType: type, inheritanceClause: inheritanceClause) {
            if let funcDecl = try createFuncDecl(declaration: declaration) {
                MemberBlockItemListSyntax {
                    funcDecl
                }
            }
        }
        
        return [queryExtension]
    }
    
    static func createFuncDecl(declaration: SwiftSyntax.DeclGroupSyntax) throws -> FunctionDeclSyntax? {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw QueryMacroError.onlyApplicableToStruct
        }
        let members = structDecl.memberBlock.members
        let variables = members.compactMap { $0.decl.as(VariableDeclSyntax.self) }
        let attributes = variables.compactMap { $0.attributes.compactMap { $0.as(AttributeSyntax.self)?.attributeName.as(IdentifierTypeSyntax.self) } }.joined()
        
        if !attributes.contains(where: { $0.description == "QueryIgnore" }) {
            return nil
        } else {
            let funcDecl = try FunctionDeclSyntax("func asQuerys() -> [URLQueryItem]") {
                
                DeclSyntax(stringLiteral:
                        """
                            var queries: [URLQueryItem] = []
                        """)

                for variable in variables {
                    let attributes = variable.attributes.compactMap { $0.as(AttributeSyntax.self) }
                    if !attributes.contains(where: { $0.attributeName.description == "QueryIgnore" }),
                        let variableBinding = variable.bindings.first {
                        
                        if let type = variableBinding.typeAnnotation?.type {
                            if type.is(OptionalTypeSyntax.self) {
                                let rawStr = "\"\\(\(variableBinding.pattern))\""
                                """
                                    if let \(variableBinding.pattern) {
                                        queries.append(URLQueryItem(name: , value: "\(raw: rawStr)"))
                                    }
                                """
                            } else {
                                let rawStr = "\"\\(self.\(variableBinding.pattern))\""
                                """
                                    queries.append(URLQueryItem(name: \(variableBinding.pattern), value: \(raw: rawStr)))
                                """
                            }
                        }
                    }
                }
                
                ReturnStmtSyntax(expression: "queries" as ExprSyntax)
            }

            return funcDecl
        }
    }
}

extension QueryableMacro: PeerMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        guard declaration.is(VariableDeclSyntax.self) else {
            throw QueryMacroError.onlyApplicableToVariable
        }
        return []
    }
}
