//
//  Models.swift
//  App
//
//  Created by Jaeson Booker on 12/4/18.
//

import Foundation
import Vapor

protocol SmartContract {
    func apply(transaction: Transaction)
}

class TransactionTypeSmartContract: SmartContract {
    func apply(transaction: Transaction) {
        var fees = 0.0
        switch transaction.transactionType {
        case .domestic:
            fees = 0.02
        case .international:
            fees = 0.05
        }
        transaction.fees = transaction.amount * fees
        transaction.amount -= transaction.fees
    }
}

enum TransactionType: String, Codable {
    case domestic
    case international
}

class Transaction: Codable {
    var from: String
    var to: String
    var amount: Double
    var fees: Double = 0.0
    var transactionType: TransactionType
    
    init(from: String, to: String, amount: Double, transactionType: TransactionType) {
        self.from = from
        self.to = to
        self.amount = amount
        self.transactionType = transactionType
    }
}
class Block {
    var index: Int = 0
    var previousHash: String = ""
    var hash: String!
    var nonce: Int
    private (set) var transactions: [Transaction] = [Transaction]()
    var key: String {
        get {
            let transactionsData = try! JSONEncoder().encode(self.transactions)
            let transactionsJSONString = String(data: transactionsData, encoding: .utf8)
            return String(self.index) + self.previousHash + String(self.nonce) + transactionsJSONString!
        }
    }
    init() {
        self.nonce = 0
    }
    func addTransaction(transaction: Transaction) {
        self.transactions.append(transaction)
    }
}
class Blockchain {
    private (set) var blocks: [Block] = [Block]()
}
let transaction = Transaction(from: "Peter", to: "Paul", amount: 2000, transactionType: .domestic)
let block1 = Block()
//block1.addTransaction(transaction: transaction)
//block1.key
