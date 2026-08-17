//
//  Error+Ext.swift
//  Lingua Quest
//
//  Created by siam on 18/08/2026.
//

import Foundation

extension Error {
    var isAIUnavailableError: Bool {
        let msg = self.localizedDescription.lowercased()
        return msg.contains("503") || 
               msg.contains("unavailable") || 
               msg.contains("high demand") || 
               msg.contains("429") || 
               msg.contains("quota") || 
               msg.contains("too many requests") || 
               msg.contains("overloaded")
    }
    
    var userFriendlyMessage: String {
        if isAIUnavailableError {
            return L10n.Common.aiServiceUnavailableSubtitle
        }
        
        let msg = self.localizedDescription
        
        // Avoid showing raw JSON or complex developer errors to the user
        if msg.contains("{") && msg.contains("}") {
            return L10n.Common.errorOccurred
        }
        
        return msg
    }
}
