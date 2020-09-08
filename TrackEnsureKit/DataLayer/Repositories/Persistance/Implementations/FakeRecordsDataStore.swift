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

    public func createRecord(record: GasRefill, completion: @escaping (Result<GasRefill, Error>) -> Void) {

    }

    public func updateRecord(record: GasRefill, completion: @escaping (Result<GasRefill, Error>) -> Void) {

    }

    public func deleteRecord(record: GasRefill, completion: @escaping (Result<GasRefill, Error>) -> Void) {
        
    }
}
