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
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarBackButtonHidden(true)
            }
            .environmentObject(vm)
   ///          View Model'i environment object yapamamızın sebebi HomeView ve homeView'in tüm child viewleri homeViewModel'e erişebilsin diye.
        }
    }
}
