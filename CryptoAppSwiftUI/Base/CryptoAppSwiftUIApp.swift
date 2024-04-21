//
//  CryptoAppSwiftUIApp.swift
//  CryptoAppSwiftUI
//
//  Created by Mine Rala on 10.04.2024.
//

import SwiftUI

@main
struct CryptoAppSwiftUIApp: App {
    @StateObject private var vm = HomeViewModel()
    @State private var showLaunchView: Bool = true
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UITableView.appearance().backgroundColor = UIColor.clear
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
                    HomeView()
                        .navigationBarBackButtonHidden(true)
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .environmentObject(vm)
       ///          View Model'i environment object yapamamızın sebebi HomeView ve homeView'in tüm child viewleri homeViewModel'e erişebilsin diye.
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
        }
    }
}
