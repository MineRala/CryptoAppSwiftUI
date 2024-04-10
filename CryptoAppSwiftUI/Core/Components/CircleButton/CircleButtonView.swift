//
//  CirclebuttonView.swift
//  CryptoAppSwiftUI
//
//  Created by Mine Rala on 10.04.2024.
//

import SwiftUI

struct CircleButtonView: View {
    let iconName: String
    var body: some View {
       Image(systemName: iconName)
            .font(.headline)
            .foregroundStyle(Color.theme.accent)
            .frame(width: 50, height: 50)
            .background(
                    Circle()
                        .foregroundStyle(Color.theme.background)
            )
            .shadow(color: Color.theme.accent.opacity(0.25), radius: 10)
            .padding()
    }
}

// previewLayout kullanabilmek içn preview'i static yapmak lazım
struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircleButtonView(iconName: "info")
                .previewLayout(.sizeThatFits)
            // Preview'i full screen den button boyutuna getiriyor
            CircleButtonView(iconName: "plus")
                .colorScheme(.dark)
                .previewLayout(.sizeThatFits)
            // Preview'i full screen den button boyutuna getiriyor
        }
    }
}

