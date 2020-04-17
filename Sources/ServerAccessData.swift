//
//  ServerAccessData.swift
//  MVCSwift
//
//  Created by David Seca on 17.04.20.
//  Copyright © 2020 David Seca. All rights reserved.
//

import Foundation

// TODO: If needed add ServerConfiguration enum for ex. test, production, staging,... enviroments
// hard-coded initial endpoints
enum BankAPI {
    case transactions

    var url: String {
        switch self {
        case .transactions: return "https://transactions"
        }
    }
}
