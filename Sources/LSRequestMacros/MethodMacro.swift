//
//  File.swift
//  
//
//  Created by czi on 2023/12/4.
//

import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import Foundation

enum MethodMacroError: CustomStringConvertible, Error {
    case onlyApplicableToStruct(String)
    
    var description: String {
        switch self {
        case .onlyApplicableToStruct(let mathod):
            return "@\(mathod) can only be applied to a struct"
        }
    }
}

public struct MethodMacro: MemberMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        guard let method = node.attributeName.as(IdentifierTypeSyntax.self)?.name else {
            return []
        }
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw MethodMacroError.onlyApplicableToStruct(method.description)
        }
        var decls: [SwiftSyntax.DeclSyntax] = []
        
        let attributes = declaration.attributes.compactMap { $0.as(AttributeSyntax.self)?.attributeName.as(IdentifierTypeSyntax.self) }
        let requestStructName =  "RequestImpl"
        /// the 'request' property
        let needInitialzier = !attributes.contains(where: { $0.name.text == "URLQuery" || $0.name.text == "HTTPBody" })
        let accessExpr = MemberAccessExprSyntax(declName: DeclReferenceExprSyntax(baseName: .keyword(.`init`)))
        let initializer = InitializerClauseSyntax(value: FunctionCallExprSyntax(callee: accessExpr))
        let requestValue = VariableDeclSyntax(modifiers: structDecl.modifiers, .let, name: PatternSyntax(stringLiteral: "request"), type: TypeAnnotationSyntax(type: IdentifierTypeSyntax(name: .identifier(requestStructName))), initializer: needInitialzier ? initializer : nil).cast(DeclSyntax.self)
        decls.append(requestValue)
        
        if !attributes.contains(where: { $0.name.text == "Payload" }) {
            let voidParser = TypeSyntax(stringLiteral: "VoidParser")
            let aliasDecl = TypeAliasDeclSyntax(modifiers: structDecl.modifiers, name: TokenSyntax(stringLiteral: "ParserImpl"), initializer: TypeInitializerClauseSyntax(value: voidParser))
            let parserValue = VariableDeclSyntax(modifiers: structDecl.modifiers, .let, name: PatternSyntax(stringLiteral: "parser"), type: TypeAnnotationSyntax(type: voidParser), initializer: initializer)
            
            decls.append(aliasDecl.cast(DeclSyntax.self))
            decls.append(parserValue.cast(DeclSyntax.self))
        }
        
        return decls
    }
}

extension MethodMacro: ExtensionMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, attachedTo declaration: some SwiftSyntax.DeclGroupSyntax, providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol, conformingTo protocols: [SwiftSyntax.TypeSyntax], in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        guard let method = node.attributeName.as(IdentifierTypeSyntax.self)?.name else {
            return []
        }
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw MethodMacroError.onlyApplicableToStruct(method.description)
        }
        
        // find all macro attrbute
        let attributes = declaration.attributes.compactMap { $0.as(AttributeSyntax.self)?.attributeName.as(IdentifierTypeSyntax.self) }
  
        let inheritanceClause = InheritanceClauseSyntax(inheritedTypesBuilder: {
            InheritedTypeSyntax(type: IdentifierTypeSyntax(name: "LSRequest.Service"))
        })
        
        let requestStructName = "RequestImpl"
        
        // create impls in extension block
        let secondExtension = try ExtensionDeclSyntax(extendedType: type, inheritanceClause: inheritanceClause) {
            try MemberBlockItemListSyntax {
                // create requet impl
                let requestInheritance = InheritanceClauseSyntax {
                    InheritedTypeListSyntax(arrayLiteral: InheritedTypeSyntax(type: IdentifierTypeSyntax(name: .identifier("LSRequest.Request"))))
                }
                
                try StructDeclSyntax(modifiers: structDecl.modifiers, name: .identifier(requestStructName), inheritanceClause: requestInheritance) {
                    // create the 'queries' property
                    if let queryAttribute = attributes.first(where: { $0.name.text == "URLQuery" }),
                       let quetyGeneric = queryAttribute.genericArgumentClause?.arguments.first?.as(GenericArgumentSyntax.self)?.description {
                        
                        VariableDeclSyntax(.let, name: PatternSyntax(stringLiteral: "queries"), type: TypeAnnotationSyntax(type: TypeSyntax(stringLiteral: quetyGeneric)))
                    }
                    // create the 'body' property
                    if let bodyAttribute = attributes.first(where: { $0.name.text == "HTTPBody" }),
                       let bodyGeneric = bodyAttribute.genericArgumentClause?.arguments.first?.as(GenericArgumentSyntax.self)?.description {
                        VariableDeclSyntax(.let, name: PatternSyntax(stringLiteral: "body"), type: TypeAnnotationSyntax(type: TypeSyntax(stringLiteral: bodyGeneric)))
                    }
                    
                    // method
                    let methidInitializer = InitializerClauseSyntax(value: ExprSyntax(stringLiteral: #"HTTPMethod(rawValue: "\#(method.text)") ?? .get"#))
                    VariableDeclSyntax(modifiers: structDecl.modifiers, .var, name: PatternSyntax(stringLiteral: "method"), initializer: methidInitializer)
       
                    // the 'url' property
                    if let segments = node.arguments?.as(LabeledExprListSyntax.self),
                       let path = segments.first?.expression.description {
        
                        if segments.count == 2, let domain = segments.last?.expression.description {
                            try VariableDeclSyntax("var url: URL") {
                                #"#URL(\#(raw: path), \#(raw: domain))"#
                            }
               
                        } else {
                            try VariableDeclSyntax("var url: URL") {
                                #"#URL(\#(raw: path), "\(self.domain)")"#
                            }
                        }
                    }
                    
                    let members = structDecl.memberBlock.members
                    let variableDecl = members.compactMap { $0.decl.as(VariableDeclSyntax.self) }
                    let variablesNames = variableDecl.compactMap { $0.bindings.first?.pattern }
                    let variablesTypes = variableDecl.compactMap { $0.bindings.first?.typeAnnotation?.type }
                    
                    // func decl
                    try createRequestFunc(attributes: attributes, modifiers: structDecl.modifiers, variablesName: variablesNames, variablesType: variablesTypes)
                }
            }
        }
        
        return [secondExtension]
    }
}

extension MethodMacro {
    static func createRequestFunc(attributes: [IdentifierTypeSyntax], 
                                  modifiers: DeclModifierListSyntax,
                                  variablesName: [PatternSyntax],
                                  variablesType: [TypeSyntax]) throws -> FunctionDeclSyntax {
        
        let attributeNames = attributes.compactMap{ $0.name.text }
        
        
        let paramterSytax = FunctionParameterClauseSyntax(parametersBuilder: {})
        let returnClauseSytax = ReturnClauseSyntax(type: TypeSyntax(stringLiteral: "URLRequest"))
        let signature = FunctionSignatureSyntax(parameterClause: paramterSytax, effectSpecifiers: FunctionEffectSpecifiersSyntax(throwsSpecifier: .keyword(.throws)), returnClause: returnClauseSytax)
        let funcDecl = try FunctionDeclSyntax(modifiers: modifiers, name: .identifier("asURLRequest"), signature: signature) {
            if attributeNames.contains("URLQuery") {
                "var url: URL = self.url"
                "let queries = queries.asQuerys()"
                
                try IfExprSyntax("if !queries.isEmpty") {
                    "var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!"
                    "components.queryItems = queries"
                    "url = components.url!"
                }
                
                
            } else {
                "let url: URL = self.url"
            }
                "var request = URLRequest(url: url)"
                "request.httpMethod = self.method.rawValue"
            if attributeNames.contains("HTTPBody") {
                try IfExprSyntax("if let data = body.asData()") {
                    "request.httpBody = data"
                }
            }
            ExprSyntax(stringLiteral: """
            headers.forEach {
                request.addValue($0.value, forHTTPHeaderField: $0.name)
            }
            """)
            "return request"
        }
        
        return funcDecl
    }
}
