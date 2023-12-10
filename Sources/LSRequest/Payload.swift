//
//  Payload.swift
//
//
//  Created by czi on 2023/12/8.
//


@attached(member, names: named(parser), named(ParserImpl))
public macro Payload<Model: Decodable>() = #externalMacro(module: "LSRequestMacros", type: "PayloadMacro")
