//
//  WordWidgetBundle.swift
//  Lingua Quest
//
//  Created by siam on 24/07/2026.
//

import WidgetKit
import SwiftUI

@main
struct WordWidgetBundle: WidgetBundle {
    var body: some Widget {
        WordWidget()
        WordWidgetControl()
        WordWidgetLiveActivity()
    }
}
