//
//  RealmRecordsDataStore.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 04.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation
import RealmSwift

public enum RealmRecordsDataStoreError: Error {
    case noSuchItem
}

public class RealmRecordsDataStore: RecordsDataStore {

    var realm = try! Realm()

    let userProfile: UserProfile

    public init(userProfile: UserProfile) {
        self.userProfile = userProfile
    }

    public func getAllRecords() -> Result<[GasRefill], Never> {
        let allRecords = realm.objects(RealmGasRefill.self)
            .filter("userUUID = %@", userProfile.email)
            .toArray()
            .map({ GasRefill(
                address: Location(latitude: $0.latitude, longitude: $0.longitude),
                addressString: $0.addressString,
                gas: Gas(provider: $0.gasProvider, type: $0.gasType),
                amount: $0.amount, price: $0.price,
                createdAt: $0.date, uuid: UUID(uuidString: $0.uuid) ?? UUID())
            })

        return .success(allRecords)
    }

    public func createRecord(record: GasRefill) -> Result<GasRefill, Error> {
        let newRecord = RealmGasRefill()
        newRecord.latitude = record.address.latitude
        newRecord.longitude = record.address.longitude
        newRecord.addressString = record.addressString
        newRecord.gasProvider = record.gas.provider
        newRecord.gasType = record.gas.type
        newRecord.amount = record.amount
        newRecord.price = record.price
        newRecord.uuid = record.uuid.uuidString
        newRecord.userUUID = userProfile.email

        do {
            realm.beginWrite()
            realm.add(newRecord)
            try realm.commitWrite()
            return .success(record)
        } catch { return .failure(error) }
    }

    public func updateRecord(record: GasRefill) -> Result<GasRefill, Error> {
        let oldRecord = readRecord(uuid: record.uuid.uuidString)

        func performUpdate(oldRecord: RealmGasRefill) -> Result<GasRefill, Error> {
            oldRecord.latitude = record.address.latitude
            oldRecord.longitude = record.address.longitude
            oldRecord.addressString = record.addressString
            oldRecord.gasProvider = record.gas.provider
            oldRecord.gasType = record.gas.type
            oldRecord.amount = record.amount
            oldRecord.price = record.price

            do {
                try realm.write { realm.add(oldRecord) }
                return .success(record)
            } catch { return .failure(error) }
        }

        switch oldRecord {
        case let .failure(error): return .failure(error)
        case let .success(oldRecord): return performUpdate(oldRecord: oldRecord) }
    }

    public func deleteRecord(record: GasRefill) -> Result<Void, Error> {
        let oldRecord = readRecord(uuid: record.uuid.uuidString)

        func performDelete(oldRecord: RealmGasRefill) -> Result<Void, Error> {
            do {
                try realm.write { realm.delete(oldRecord) }
                return .success(())
            } catch { return .failure(error) }
        }

        switch oldRecord {
        case let .failure(error): return .failure(error)
        case let .success(oldRecord): return performDelete(oldRecord: oldRecord) }
    }

    private func readRecord(uuid: String) -> Result<RealmGasRefill, Error> {
        let filtered = realm.objects(RealmGasRefill.self).filter("uuid = %@", uuid).first
        guard let oldRecord = filtered else { return .failure(RealmRecordsDataStoreError.noSuchItem)}
        return .success(oldRecord)
    }

}


extension Results {
    func toArray() -> [Element] {
        return compactMap { $0 }
    }
}
