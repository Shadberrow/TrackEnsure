//
//  Location.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

public struct Location: Codable, Equatable {
    
    // MARK: - Properties
    public var latitude: Double
    public var longitude: Double

    // MARK: - Methods
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
