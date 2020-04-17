//
//  TransactionManager.swift
//  MVCSwift
//
//  Created by David Seca on 17.04.20.
//  Copyright © 2020 David Seca. All rights reserved.
//

import Foundation

public class TransactionManager {

    public init() {
        self.persistence.fetch(Transaction.self, sortedBy: Transaction.dateSortDescriptor) { [weak self] (transactions) in
            self?.transactions = transactions
            NotificationCenter.default.post(name: .transactionsChanged, object: nil)
        }
    }

    static var shared = TransactionManager()

    let persistence = CoreDataManager.shared

    private(set) var transactions = [Transaction]()

    var oldTransactions: [Transaction] {
        return Array(self.transactions.dropFirst())
    }

    var lastTransaction: Transaction? {
        return self.transactions.first
    }

    private var networkDelegate: NetworkManagerProtocol = NetworkManager.sharedInstance

    private(set) var loading = false

    // Will be called from MockNetworkManager for testing pourposes
    func set(networkDelegate: NetworkManagerProtocol) {
        self.networkDelegate = networkDelegate
    }

    func loadIfNeeded() {
        if !self.loading {
            self.loading = true

            networkDelegate.getContent(content: .transactions) { data, isOffline in
                guard
                    let data = data,
                    let dtoArray = try? JSONDecoder().decode([TransactionDTO].self, from: data)
                else {
                    return
                }

                // Just swifty filter for saving only what we need
                let sortedDtoArray = dtoArray.filter { $0.date != nil }.sorted { $0.date! > $1.date! }
                var uniquesDtoArray = [TransactionDTO]()
                sortedDtoArray.forEach { ti in
                    let t = uniquesDtoArray.filter { $0.id == ti.id }.first
                    if t == nil {
                        uniquesDtoArray.append(ti)
                    }
                }

                uniquesDtoArray.forEach { dto in
                    assert(dto.date != nil)

                    if let date = dto.date {
                        let t = Transaction(context: self.persistence.context)
                        t.id = Int32(dto.id)
                        t.amount = dto.amount
                        t.fee = dto.fee ?? 0
                        t.desc = dto.description
                        t.date = date
                    }
                }

                // Used CoreData as persistance.
                // NB: if complex queries needed and/or frequent changes on models, another approach like SQLite should reconsidered
                self.persistence.saveAndFetch(Transaction.self, sortedBy: Transaction.dateSortDescriptor) { transactions in
                    self.transactions = transactions
                    NotificationCenter.default.post(name: .transactionsChanged, object: nil)
                    self.loading = false
                }
            }
        }
    }
}
