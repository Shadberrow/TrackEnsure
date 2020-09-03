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
        return .success([GasRefill.record_01, GasRefill.record_02])
    }

    public func saveRecord(record: GasRefill) -> Result<GasRefill, Error> {
        return undefined()
    }

    public func getRecord(id: UUID) -> Result<GasRefill, Error> {
        return undefined()
    }
}
