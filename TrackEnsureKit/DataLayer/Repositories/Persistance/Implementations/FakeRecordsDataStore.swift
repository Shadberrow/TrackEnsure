//
//  FakeRecordsDataStore.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 03.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

public class FakeRecordsDataStore: RecordsDataStore {

    // MARK: - Methods
    public init() {}

    public func getAllRecords() -> Result<[GasRefill], Never> {
        return undefined()
    }

    public func saveRecord(record: GasRefill) -> Result<GasRefill, Error> {
        return undefined()
    }

    public func getRecord(id: UUID) -> Result<GasRefill, Error> {
        return undefined()
    }
}
