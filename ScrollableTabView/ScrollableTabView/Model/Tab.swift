//
//  Tab.swift
//  ScrollableTabView
//
//  Created by yangyang on 2024/1/29.
//

import SwiftUI

/// Tabs
enum Tab: String, CaseIterable {
    case chats = "Chats"
    case calls = "Calls"
    case settings = "Settings"
    
    var systemImage: String {
        switch self {
        case .calls:
            return "phone"
        case .chats:
            return "bubble.left.and.bubble.right"
        case .settings:
            return "gear"
        }
    }
}
