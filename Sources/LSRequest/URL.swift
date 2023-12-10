//
//  File.swift
//  
//
//  Created by czi on 2023/12/6.
//

import Foundation

@freestanding(expression)
public macro URL(_ string: String, _ relativeTo: String? = nil) -> URL = #externalMacro(module: "LSRequestMacros", type: "URLMacro")
