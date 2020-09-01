//
//  GasStation.swift
//  TrackEnsure
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

public struct GasRefill: Codable, Equatable {

    // MARK: - Properties
    public let address: Location
    public let gas: Gas
    public let amount: Double
    public let price: Double

    // MARK: - Methods
    public init(address: Location, gas: Gas, amount: Double, price: Double) {
        self.address = address
        self.gas = gas
        self.amount = amount
        self.price = price
    }
}
