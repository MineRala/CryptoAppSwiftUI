//
//  DetailView.swift
//  CryptoAppSwiftUI
//
//  Created by Mine Rala on 19.04.2024.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack {
            if let coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    let coin: CoinModel

    init(coin: CoinModel) {
        self.coin = coin
        print("Initializing Detail View for\(coin.name)")
    }

    var body: some View {
        Text(coin.name)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: dev.coin)
    }
}
