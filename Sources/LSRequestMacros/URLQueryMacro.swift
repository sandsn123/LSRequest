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
import SwiftCompilerPluginMessageHandling
import SwiftDiagnostics
import SwiftSyntaxMacrosTestSupport

enum URLQueryError: CustomStringConvertible, Error {
    case mustAddMethodMacroAtSameTime
    case onlyApplicableToStruct
    
    var description: String {
        switch self {
        case .onlyApplicableToStruct:
            return "@URLQuery can only be applied to a struct"
        case .mustAddMethodMacroAtSameTime:
            return "@URLQuery must add method macro at same time"
        }
    }
}

public struct URLQueryMacro: PeerMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw URLQueryError.onlyApplicableToStruct
        }
        let attributeNames = structDecl.attributes.compactMap { $0.as(AttributeSyntax.self)?.attributeName.as(IdentifierTypeSyntax.self) }
        let macros = attributeNames.compactMap { $0.name.text }
        let methods = ["GET", "POST", "PUT", "DELETE", "PATCH", "HEAD"]
        guard macros.contains(where: {
            methods.contains($0)
        }) else {
            throw URLQueryError.mustAddMethodMacroAtSameTime
        }
        return []
    }
}
 
