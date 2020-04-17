//
//  Transaction.swift
//  MVCSwift
//
//  Created by David Seca on 17.04.20.
//  Copyright © 2020 David Seca. All rights reserved.
//

import Foundation
import CoreData

@objc(Transaction)
public class Transaction: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: Double
    @NSManaged public var date: Date
    @NSManaged public var desc: String?
    @NSManaged public var fee: Double
    @NSManaged public var id: Int32

    var total: Double {
         return self.amount + self.fee
    }

    static let dateSortDescriptor = [NSSortDescriptor(key: "date", ascending: false)]
}
