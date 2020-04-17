//
//  TransactionTableViewCell.swift
//  MVCSwift
//
//  Created by David Seca on 17.04.20.
//  Copyright © 2020 David Seca. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    @IBOutlet weak var transactionView: TransactionDisplayView!

    override func awakeFromNib() {
        self.transactionView.awakeFromNib()
    }

    override func prepareForReuse() {
        self.transactionView.prepareForReuse()
    }

    func set(transaction: Transaction) {
        self.transactionView.set(transaction: transaction)
    }
}
