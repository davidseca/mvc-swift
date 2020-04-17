//
//  TransactionDTO.swift
//  MVCSwift
//
//  Created by David Seca on 17.04.20.
//  Copyright © 2020 David Seca. All rights reserved.
//


import Foundation

public class TransactionDTO: Decodable {
    let id: Int
    let rawDate: String?
    let amount: Double
    let fee: Double?
    let description: String?

    let date: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case rawDate = "date"
        case amount
        case fee
        case description
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.rawDate = try container.decodeIfPresent(String.self, forKey: .rawDate)
        self.amount = try container.decode(Double.self, forKey: .amount)
        self.fee = try container.decodeIfPresent(Double.self, forKey: .fee)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)

        self.date = DateFormatter.iSO8601DateWithMillisec.date(from:  rawDate ?? "n/a")
    }
}
