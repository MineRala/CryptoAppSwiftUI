//
//  HapticManager.swift
//  CryptoAppSwiftUI
//
//  Created by Mine Rala on 19.04.2024.
//

import Foundation
import SwiftUI

final class HapticManager {
    static let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
