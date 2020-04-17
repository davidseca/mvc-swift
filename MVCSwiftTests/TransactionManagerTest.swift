//
//  TransactionManagerTest.swift
//  MVCSwiftTests
//
//  Created by David Seca on 17.04.20.
//  Copyright © 2020 David Seca. All rights reserved.
//

import XCTest

@testable import MVCSwift

class TransactionManagerTest: XCTestCase {

    func test_transactions_parse() {

        // given
        let transactionManager = TransactionManager()
        transactionManager.set(networkDelegate: MockNetworkManager())

        //when
        transactionManager.loadIfNeeded()

        //then
        let transactions = transactionManager.transactions
        let oldTransactions = transactionManager.oldTransactions
        let lastTransaction = transactionManager.lastTransaction

        XCTAssert(transactions.count == 4)
        XCTAssert(transactions.first?.date == lastTransaction?.date)
        XCTAssert(lastTransaction?.date == transactions.map { $0.date }.max())
        XCTAssert(oldTransactions.map { $0.date }.max()! < transactions.map { $0.date }.max()!)
    }

    func test_transactions_last() {

        // given
        let transactionManager = TransactionManager()
        transactionManager.set(networkDelegate: MockNetworkManager())

        //when
        transactionManager.loadIfNeeded()

        //then
        let lastTransaction = transactionManager.lastTransaction

        XCTAssert(lastTransaction?.id == 5)
        XCTAssert(lastTransaction?.amount == 87.84)
        XCTAssert(lastTransaction?.fee == -1.11)
        XCTAssert(lastTransaction?.total == 86.73)
        XCTAssert(lastTransaction?.desc == "Transaction 5")
        XCTAssert(lastTransaction?.date == DateFormatter.iSO8601DateWithMillisec.date(from: "2018-07-06T17:56:43.000Z"))
    }

    func test_transactions_wrongDate() {

        // given
        let transactionManager = TransactionManager()
        transactionManager.set(networkDelegate: MockNetworkManager())

        //when
        transactionManager.loadIfNeeded()

        //then
        let transactions = transactionManager.transactions

        XCTAssert(!transactions.map {$0.id}.contains(4))
    }

    func test_transactions_duplicateIds() {

        // given
        let transactionManager = TransactionManager()
        transactionManager.set(networkDelegate: MockNetworkManager())

        //when
        transactionManager.loadIfNeeded()

        //then
        let transactions = transactionManager.transactions

        XCTAssert(transactions.filter { $0.id == 5 }.count == 1)
        XCTAssert(transactions.filter { $0.id == 5 }.first?.date == DateFormatter.iSO8601DateWithMillisec.date(from: "2018-07-06T17:56:43.000Z"))
    }
}
