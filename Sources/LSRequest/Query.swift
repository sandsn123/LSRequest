//
//  File.swift
//  
//
//  Created by czi on 2023/12/5.
//

@attached(extension, conformances: Queryable, names: named(asQuerys))
public macro Queryable() = #externalMacro(module: "LSRequestMacros", type: "QueryableMacro")

@attached(peer)
public macro QueryIgnore() = #externalMacro(module: "LSRequestMacros", type: "QueryableMacro")

@attached(peer)
public macro URLQuery<Item: Queryable>() = #externalMacro(module: "LSRequestMacros", type: "URLQueryMacro")
