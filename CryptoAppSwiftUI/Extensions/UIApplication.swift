//
//  UIApplication.swift
//  CryptoAppSwiftUI
//
//  Created by Mine Rala on 17.04.2024.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        // Metin alanından çıktığımızda klavyenin otomatik olarak kapanmasını sağlar
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
