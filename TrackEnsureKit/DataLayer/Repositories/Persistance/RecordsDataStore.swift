//
//  RecordsDataStore.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 03.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

public protocol RecordsDataStore {

    func getAllRecords() -> Result<[GasRefill], Never>
    func createRecord(record: GasRefill) -> Result<GasRefill, Error>
    func updateRecord(record: GasRefill) -> Result<GasRefill, Error>
    func deleteRecord(record: GasRefill) -> Result<Void, Error>
}
