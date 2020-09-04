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
    public let addressString: String
    public let gas: Gas
    public let amount: Double
    public let price: Double
    public let createdAt: Date
    public let uuid: UUID

    // MARK: - Methods
    public init(address: Location, addressString: String, gas: Gas, amount: Double, price: Double, createdAt: Date, uuid: UUID) {
        self.address = address
        self.addressString = addressString
        self.gas = gas
        self.amount = amount
        self.price = price
        self.createdAt = createdAt
        self.uuid = uuid
    }
}


public extension GasRefill {

    static let record_01 = GasRefill(address: Location(latitude: -33.864308, longitude: 151.209146),
                                     addressString: "12 Some Address",
                                     gas: Gas(provider: "", type: ""),
                                     amount: 20, price: 20*25,
                                     createdAt: Date(), uuid: UUID())

    static let record_02 = GasRefill(address: Location(latitude: -33.864308, longitude: 151.209146),
                                     addressString: "13 Some Address",
                                     gas: Gas(provider: "", type: ""),
                                     amount: 20, price: 20*25,
                                     createdAt: Date(), uuid: UUID())
}
