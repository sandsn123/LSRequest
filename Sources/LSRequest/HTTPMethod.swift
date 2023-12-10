//
//  HTTPMethod.swift
//
//
//  Created by czi on 2023/12/5.
//

@attached(member, names: named(RequestImpl), named(ParserImpl), named(request), named(parser))
@attached(extension, conformances: Service, names: arbitrary)
public macro GET(_ path: StaticString = "", domain: String? = nil) = #externalMacro(module: "LSRequestMacros", type: "MethodMacro")

@attached(member, names: named(RequestImpl), named(ParserImpl), named(request), named(parser))
@attached(extension, conformances: Service, names: arbitrary)
public macro POST(_ path: String = "") = #externalMacro(module: "LSRequestMacros", type: "MethodMacro")

@attached(member, names: named(RequestImpl), named(ParserImpl), named(request), named(parser))
@attached(extension, conformances: Service, names: arbitrary)
public macro PUT(_ path: String = "") = #externalMacro(module: "LSRequestMacros", type: "MethodMacro")

@attached(member, names: named(RequestImpl), named(ParserImpl), named(request), named(parser))
@attached(extension, conformances: Service, names: arbitrary)
public macro PATCH(_ path: String = "") = #externalMacro(module: "LSRequestMacros", type: "MethodMacro")

@attached(member, names: named(RequestImpl), named(ParserImpl), named(request), named(parser))
@attached(extension, conformances: Service, names: arbitrary)
public macro DELETE(_ path: String = "") = #externalMacro(module: "LSRequestMacros", type: "MethodMacro")

@attached(member, names: named(RequestImpl), named(ParserImpl), named(request), named(parser))
@attached(extension, conformances: Service, names: arbitrary)
public macro OPTIONS(_ path: String = "") = #externalMacro(module: "LSRequestMacros", type: "MethodMacro")

@attached(member, names: named(RequestImpl), named(ParserImpl), named(request), named(parser))
@attached(extension, conformances: Service, names: arbitrary)
public macro HEAD(_ path: String = "") = #externalMacro(module: "LSRequestMacros", type: "MethodMacro")

public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case options = "OPTIONS"
    case head    = "HEAD"
}
