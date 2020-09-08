//
//  FirebaseRecordsDataStore.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 04.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation
import FirebaseDatabase
import SwiftQueue

public enum FirebaseRecordsDataStoreError: Error {
    case jsonSerializationFailed
    case databaseChildNode
    case badUUID
}

public class FirebaseRecordsDataStore {

    let userSession: RemoteUserSession
    let manager: SwiftQueueManager
    let apiReference: DatabaseReference

    public init(userSession: RemoteUserSession) {
        self.userSession = userSession
        self.apiReference = Database.database().reference().child("users").child(userSession.token).child("records")
        let jobCreator = GasRefillJobCreator(apiReference: apiReference)
        self.manager = SwiftQueueManagerBuilder(creator: jobCreator).build()
    }

    public func upload(record: GasRefill) {
        let params = getParams(for: record)
        JobBuilder(type: GasRefillCreateJob.type)
            .internet(atLeast: .cellular)
            .with(params: params)
            .schedule(manager: manager)
    }

    public func delete(record: GasRefill) {
        let params = getParams(for: record)
        JobBuilder(type: GasRefillDeleteJob.type)
            .internet(atLeast: .cellular)
            .with(params: params)
            .schedule(manager: manager)
    }

    private func getParams(for record: GasRefill) -> [String: Any] {
        return [
            "date": record.createdAt.timeIntervalSince1970,
            "latitude": record.address.latitude,
            "longitude": record.address.longitude,
            "addressString": record.addressString,
            "gasProvider": record.gas.provider,
            "gasType": record.gas.type,
            "amount": record.amount,
            "price": record.price,
            "uuid": record.uuid,
        ]
    }
}



public class GasRefillCreateJob: Job {

    // Type to know which Job to return in job creator
    static let type = "GasRefillCreateJob"
    // Param
    private let record: [String: Any]
    private let apiReference: DatabaseReference

    required init(record: [String: Any], apiReference: DatabaseReference) {
        // Receive params from JobBuilder.with()
        self.record = record
        self.apiReference = apiReference
    }

    public func onRun(callback: JobResult) {
        guard let uuid = record["uuid"] as? String else { return callback.done(.fail(FirebaseRecordsDataStoreError.badUUID)) }
        apiReference.child(uuid).setValue(record)
        callback.done(.success)
    }

    public func onRetry(error: Error) -> RetryConstraint {
        return error is FirebaseRecordsDataStoreError ? RetryConstraint.cancel : RetryConstraint.retry(delay: 0) // immediate retry
    }

    public func onRemove(result: JobCompletion) {
        switch result {
            case .success: print("Job Success")
            case .fail(let error): print(error)
        }
    }
}

public class GasRefillDeleteJob: Job {

    // Type to know which Job to return in job creator
    static let type = "GasRefillDeleteJob"
    // Param
    private let record: [String: Any]
    private let apiReference: DatabaseReference

    required init(record: [String: Any], apiReference: DatabaseReference) {
        // Receive params from JobBuilder.with()
        self.record = record
        self.apiReference = apiReference
    }

    public func onRun(callback: JobResult) {
        guard let uuid = record["uuid"] as? String else { return callback.done(.fail(FirebaseRecordsDataStoreError.badUUID)) }
        apiReference.child(uuid).removeValue()
        callback.done(.success)
    }

    public func onRetry(error: Error) -> RetryConstraint {
        return error is FirebaseRecordsDataStoreError ? RetryConstraint.cancel : RetryConstraint.retry(delay: 0) // immediate retry
    }

    public func onRemove(result: JobCompletion) {
        switch result {
            case .success: print("Job Success")
            case .fail(let error): print(error)
        }
    }
}

public class GasRefillJobCreator: JobCreator {

    private let apiReference: DatabaseReference

    public init(apiReference: DatabaseReference) {
        self.apiReference = apiReference
    }

    public func create(type: String, params: [String: Any]?) -> Job {
        if type == GasRefillCreateJob.type  {
            guard let params = params else { fatalError("No Parameters for \(type) type") }
            return GasRefillCreateJob(record: params, apiReference: apiReference)
        } else if type == GasRefillDeleteJob.type {
            guard let params = params else { fatalError("No Parameters for \(type) type") }
            return GasRefillDeleteJob(record: params, apiReference: apiReference)
        } else {
            // Nothing match
            // You can use `fatalError` or create an empty job to report this issue.
            fatalError("No Job !")
        }
    }
}
