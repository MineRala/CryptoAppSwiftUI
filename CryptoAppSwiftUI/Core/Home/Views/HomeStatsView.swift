//
//  HomeStatsView.swift
//  CryptoAppSwiftUI
//
//  Created by Mine Rala on 17.04.2024.
//

import SwiftUI

struct HomeStatsView: View {
    @ObservedObject var vm: HomeViewModel
    @Binding var showPortfolio: Bool

    var body: some View {
        HStack {
            ForEach(vm.statistics) { stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading)
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView(vm: dev.homeVM, showPortfolio: .constant(false))
    }
}
