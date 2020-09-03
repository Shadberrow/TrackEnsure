//
//  GasRefill.swift
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
    public let uuid: UUID = UUID()

    // MARK: - Methods
    public init(address: Location, gas: Gas, amount: Double, price: Double) {
        self.address = address
        self.gas = gas
        self.amount = amount
        self.price = price
    }
}


public extension GasRefill {

    static let record_01 = GasRefill(address: Location(latitude: -33.864308, longitude: 151.209146),
                                     gas: Gas(provider: "", type: ""),
                                     amount: 20, price: 20*25)

    static let record_02 = GasRefill(address: Location(latitude: -33.864308, longitude: 151.209146),
                                     gas: Gas(provider: "", type: ""),
                                     amount: 20, price: 20*25)

}
