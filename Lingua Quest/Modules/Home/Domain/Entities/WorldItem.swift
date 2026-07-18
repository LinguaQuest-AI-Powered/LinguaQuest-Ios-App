//
//  WorldItem.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 17/07/2026.
//

import Foundation
import SwiftUI


struct WorldItem: Identifiable {
    let id = UUID()
    let title: String
    let imageName: Image.Asset
    let difficulty: String
    let progress: Double
    let isCompleted: Bool
}
