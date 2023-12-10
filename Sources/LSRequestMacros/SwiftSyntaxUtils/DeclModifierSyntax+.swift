//
//  File.swift
//  
//
//  Created by czi on 2023/12/5.
//

import SwiftSyntax

extension DeclModifierSyntax {
    var isNeededAccessLevelModifier: Bool {
        switch self.name.tokenKind {
        case .keyword(.public): return true
        default: return false
        }
    }
}
