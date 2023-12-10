//
//  HTTPBody.swift
//
//
//  Created by czi on 2023/12/5.
//

@attached(extension, conformances: BodyEncodable, names: named(asData))
public macro BodyEncodable() = #externalMacro(module: "LSRequestMacros", type: "BodyEncodableMacro")

@attached(peer)
public macro HTTPBodyIgnore() = #externalMacro(module: "LSRequestMacros", type: "BodyEncodableMacro")

@attached(peer)
public macro HTTPBody<Body: BodyEncodable>() = #externalMacro(module: "LSRequestMacros", type: "HTTPBodyMacro")
