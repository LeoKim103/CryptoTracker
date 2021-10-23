//
//  HapticManager.swift
//  CryptoTracker
//
//  Created by Leo Kim on 23/10/2021.
//

import Foundation
import SwiftUI

class HapticManager {
    private static let generator = UINotificationFeedbackGenerator()

    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
