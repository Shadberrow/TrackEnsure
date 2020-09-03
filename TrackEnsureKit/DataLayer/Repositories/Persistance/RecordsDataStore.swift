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
    func saveRecord(record: GasRefill) -> Result<GasRefill, Error>
    func getRecord(id: UUID) -> Result<GasRefill, Error>
}
