//
//  Image.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import SwiftUI

extension Image {
    
  
    enum Icon: String {
        case google = "googleIcon"
        case apple = "appleIcon"
    }
    
    enum SystemIcon: String {
        case eyeFill = "eye.fill"
        case eyeSlashFill = "eye.slash.fill"
        case lockFill = "lock.fill"
        case envelopeFill = "envelope.fill"
    }
    
    enum Asset: String {
        case dialogMascot = "image"
    }
    
    init(icon: Icon) {
        self.init(icon.rawValue)
    }
    
    init(asset: Asset) {
        self.init(asset.rawValue)
    }
    
    init(systemIcon: SystemIcon) {
        self.init(systemName: systemIcon.rawValue)
    }
}
