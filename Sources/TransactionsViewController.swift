//
//  TransactionsViewController.swift
//  MVCSwift
//
//  Created by David Seca on 17.04.20.
//  Copyright © 2020 David Seca. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class TransactionsViewController: UIViewController {

    @IBOutlet weak var lastTransactionView: TransactionDisplayView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    static let cellIdentifier = "transactionCell"

    var lastTransaction: Transaction?
    var oldTransactions = [Transaction]()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        self.title = L10n.Tabbar.transactions
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.register(UINib(nibName: "TransactionTableViewCell", bundle: nil), forCellReuseIdentifier: TransactionsViewController.cellIdentifier)

        let transactionManager = TransactionManager.shared
        self.lastTransaction = transactionManager.lastTransaction
        self.oldTransactions = transactionManager.oldTransactions

        NotificationCenter.default.addObserver(self, selector: #selector(self.transactionsChanged), name: .transactionsChanged, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.updateView()
    }

    func updateView() {
        if TransactionManager.shared.loading && self.lastTransaction == nil {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }

        self.lastTransactionView.isHidden = self.lastTransaction == nil

        if let transaction = self.lastTransaction {
            self.lastTransactionView.set(transaction: transaction)
        }

        self.tableView.separatorStyle = self.oldTransactions.count == 0 ? .none : .singleLine
        self.tableView.reloadData()
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate delegate
extension TransactionsViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.oldTransactions.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionsViewController.cellIdentifier, for: indexPath) as! TransactionTableViewCell
        let transaction = self.oldTransactions[indexPath.row]
        cell.set(transaction: transaction)
        return cell
    }
}

// MARK: - DZNEmptyDataSetDelegate, DZNEmptyDataSetSource delegate
extension TransactionsViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: L10n.Transactions.Empty.title)
    }

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return self.oldTransactions.count == 0
    }

}

// MARK: - Notification handlers
extension TransactionsViewController {

    @objc func transactionsChanged(_ notification: Notification) {
        let transactionManager = TransactionManager.shared
        self.lastTransaction = transactionManager.lastTransaction
        self.oldTransactions = transactionManager.oldTransactions

        self.updateView()
    }

}
