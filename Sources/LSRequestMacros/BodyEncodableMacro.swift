//
//  File.swift
//  
//
//  Created by czi on 2023/12/7.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder


public struct BodyEncodableMacro: ExtensionMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, attachedTo declaration: some SwiftSyntax.DeclGroupSyntax, providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol, conformingTo protocols: [SwiftSyntax.TypeSyntax], in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        
        let inheritanceClause = InheritanceClauseSyntax(inheritedTypesBuilder: {
              InheritedTypeSyntax(type: IdentifierTypeSyntax(name: "BodyEncodable"))
            })
        
        let queryExtension = ExtensionDeclSyntax(extendedType: type, inheritanceClause: inheritanceClause) {}
        return [queryExtension]
    }
}

extension BodyEncodableMacro: PeerMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        []
    }
}
