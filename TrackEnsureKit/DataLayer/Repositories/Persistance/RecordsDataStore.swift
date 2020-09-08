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
    func createRecord(record: GasRefill, completion: @escaping (Result<GasRefill, Error>) -> Void)
    func updateRecord(record: GasRefill, completion: @escaping (Result<GasRefill, Error>) -> Void)
    func deleteRecord(record: GasRefill, completion: @escaping (Result<GasRefill, Error>) -> Void)
}
