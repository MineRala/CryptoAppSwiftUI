//
//  String.swift
//  CryptoAppSwiftUI
//
//  Created by Mine Rala on 20.04.2024.
//

import Foundation

extension String {
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
