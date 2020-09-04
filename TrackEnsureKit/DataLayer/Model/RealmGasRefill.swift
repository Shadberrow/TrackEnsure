//
//  RealmGasRefill.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 04.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation
import RealmSwift

internal class RealmGasRefill: Object {

    // MARK: - Properties
    @objc dynamic var date: Date = Date()
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var addressString: String = ""
    @objc dynamic var gasProvider: String = ""
    @objc dynamic var gasType: String = ""
    @objc dynamic var amount: Double = 0.0
    @objc dynamic var price: Double = 0.0
    @objc dynamic var uuid: String = UUID().uuidString
    @objc dynamic var userUUID: String?

    // MARK: - Methods
    open override class func primaryKey() -> String? {
        return "uuid"
    }
}
