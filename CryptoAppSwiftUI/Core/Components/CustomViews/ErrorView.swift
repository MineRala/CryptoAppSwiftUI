//
//  ErrorView.swift
//  CryptoAppSwiftUI
//
//  Created by Mine Rala on 22.04.2024.
//

import SwiftUI

struct ErrorView: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.callout)
            .fontWeight(.regular)
            .foregroundStyle(Color.theme.secondaryText)
            .padding()
    }
}

#Preview {
    ErrorView(message: "ERRORR!!!!!")
}
