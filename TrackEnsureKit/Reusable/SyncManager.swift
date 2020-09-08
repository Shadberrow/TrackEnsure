//
//  SyncManager.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 08.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation
import Alamofire
import SwiftQueue


//public class SyncManager: SwiftQueueManager {
//
//    init() { }
//
//}

//let SyncMangerIdentifier = "com.example.background.syncmanger"
//
//class SyncManager: Alamofire.NetworkReachabilityManager {
//
//    static let instance = SyncManager()
//    private var pendingTasks = []() // SyncTask is a class with  3 variables [image,audio,[tags]] that are being uploading to server
//    private var request: Request?
//    private var isSyncing = false
//
//
//    private init(){
//        let configuration = URLSessionConfiguration.background(withIdentifier: SyncMangerIdentifier)
//        configuration.allowsCellularAccess = Config.cellularAccess
//        super.init(configuration: configuration)
//    }
//
//    // CALL THIS FUNCTION TO START THE SYNC
//    // variable isSyncing guards multiple execution of syncManager
//    func start(){
//        guard !isSyncing else {
//            // WE ARE ALREADY SYNCING
//            return
//        }
//
//        // CALL TO PREPARE FUNCTION TO EVALUATE WHETHER WE CAN SYNC OR NOT
//        prepare()
//    }
//
//
//    /*
//     initialize the syncItem variable with the first entry from SyncTask
//     if we are stopping return
//     if syncTask isEmpty stop
//     if there are no items in first syncTask remove the task and restart the process.
//
//     */
//    private func prepare(){
//
//        // I use a database query to store & retrieve pendingTasks
//
//        guard !pendingTasks.isEmpty else{
//            // todo no more data to sync
//            isSyncing = false // syncing process ended
//
//            // Notify app that your long running task has finished
//            (UIApplication.sharedApplication().delegate as? AppDelegate)?.endBackgroundSyncTask()
//            return
//        }
//
//        isSyncing = true // we are in syncing process
//
//        // Notify app that our long running task has begun
//        (UIApplication.sharedApplication().delegate as? AppDelegate)?.beginBackgroundRestoreTask()
//
//        // Call function to start the first upload
//        uploadFileOrData()
//    }
//}
//
//
///**
// upload the files & data from array recursively
// */
//private func uploadFileOrData(){
//    var task = pendingTasks[0]
//
//    let imageUrl = task.imageUrl
//    let audioUrl = task.audioUrl
//    let tags = task.tags.reduce(""){ prev, next in
//        if prev.isEmpty{
//            return next.text
//        }
//        return "\(prev),\(next.text)"
//    }
//
//    let form : (MultipartFormData) -> () = { data  in
//
//        if imageUrl.checkResourceIsReachableAndReturnError(nil){
//            data.appendBodyPart(fileURL: imageUrl, name: "image")
//        }
//
//        if audioUrl.checkResourceIsReachableAndReturnError(nil){
//            data.appendBodyPart(fileURL: audioUrl, name: "audio")
//        }
//        data.appendBodyPart(data: tags.dataUsingEncoding(NSUTF8StringEncoding,allowLossyConversion: false)!, name: "tags")
//
//    }
//
//    upload(.POST, Api.fileUploadUrl, multipartFormData: form ,encodingCompletion: {
//
//        // Call function to process the response
//        self.processUploadFileResponse($0)
//    })
//}
//
//private func processUploadFileResponse(result: Manager.MultipartFormDataEncodingResult){
//    switch result {
//    case .Success(let upload, _, _):
//
//        // PERFORM ACTION ON SUCCESS
//
//        // MOVE TO NEXT LOCATION
//        self.moveToNextTask()
//
//    case .Failure(_):
//        // PERFORM ACTION ON FALIURE
//
//        // MOVE TO NEXT LOCATION
//        self.moveToNextTask()
//    }
//}
//
//
//
//
//private func moveToNextTask(){
//    // DELETE pendingTasks[0] & CALL prepare() function
//
//    // If you want to repeat after every 10 MINUTE
//    // Then wrap your function call 'prepare()' inside dispatch_after
//
//
//    dispatch_after(
//        dispatch_time(
//            DISPATCH_TIME_NOW,
//            Int64(10 * 60 * Double(NSEC_PER_SEC))  // 10 * 60 to convert seconds into minute
//        ),
//        dispatch_get_main_queue(), {
//            self.prepare()
//    })
//
//}
