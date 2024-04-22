//
//  PortfolioDataService.swift
//  CryptoAppSwiftUI
//
//  Created by Mine Rala on 19.04.2024.
//

import Foundation
import CoreData

final class PortfolioDataService {

    private let container: NSPersistentContainer
    @Published var savedEntities: [PortfolioEntity] = []

    init() {
        container = NSPersistentContainer(name: "PortfolioContainer")
        container.loadPersistentStores { _, error in
            if let error  {
                print("Error loading Core Data! \(error)")
            }
        }
        getPortfolio()
    }
    
    // MARK: - Public
    func updatePortfolio(coin: CoinModel, amount: Double) {
        // check if coin is already in portfolio
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                update(entitiy: entity, amount: amount)
            } else {
                delete(entitiy: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }

    // MARK: - Private
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: "PortfolioEntity")
        do {
             savedEntities = try container.viewContext.fetch(request)
        } catch let error{
            print("Error fetching Portfolio Entities. \(error)")
        }
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entitiy = PortfolioEntity(context: container.viewContext)
        entitiy.coinID = coin.id
        entitiy.amount = amount
        applyChanges()
    }
    
    private func update(entitiy: PortfolioEntity, amount: Double) {
        entitiy.amount = amount
        applyChanges()
    }
    
    private func delete(entitiy: PortfolioEntity) {
        container.viewContext.delete(entitiy)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
}
