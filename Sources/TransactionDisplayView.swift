//
//  TransactionDisplayView.swift
//  MVCSwift
//
//  Created by David Seca on 17.04.20.
//  Copyright © 2020 David Seca. All rights reserved.
//

import UIKit

/**
 Display a Transaction. This is used both on the TransactionCell and TransactionHeaderView
 */
class TransactionDisplayView: IBDesignableView {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var idTitleLabel: UILabel!
    @IBOutlet weak var idValueLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func nibName() -> String {
        return "TransactionDisplayView"
    }

    override func awakeFromNib() {
        self.prepareForReuse()
    }

    func prepareForReuse() {
        self.dateLabel.text = "n/a"
        self.idTitleLabel.text = L10n.Transaction.Reference.title
        self.idValueLabel.text = "n/a"
        self.amountLabel.text = "n/a"
        self.descriptionLabel.text = nil
    }

    func set(transaction: Transaction) {
        self.idValueLabel.text = "\(transaction.id)"
        self.amountLabel.text = String(format: "%.2f", transaction.total)
        self.amountLabel.textColor = transaction.total > 0 ? UIColor.green : UIColor.red
        self.descriptionLabel.text = transaction.desc

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = L10n.Date.format
        self.dateLabel.text = dateFormatter.string(from: transaction.date)
    }
}
