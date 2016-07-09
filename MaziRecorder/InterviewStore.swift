//
//  InterviewStore.swift
//  MaziRecorder
//
//  Created by Erich Grunewald on 08/07/16.
//  Copyright © 2016 Erich Grunewald. All rights reserved.
//

import Foundation
import ReactiveCocoa

class InterviewStore: NSObject {
    
    static let sharedInstance = InterviewStore()
    
    let interviews = MutableProperty<[Interview]>([])
    
    private let archiveFileName = "InterviewStore"
    
    func createInterview() -> Interview {
        let interview = Interview()
        var interviewsArray = interviews.value
        interviewsArray.append(interview)
        interviews.value = interviewsArray
        
        print("Created interview \(interview)")
        
        return interview
    }
    
    func fetchLatestIncompleteOrCreateNewInterview() -> Interview {
        let reverseInterviews = interviews.value.reverse() // Latest first.
        if let index = reverseInterviews.indexOf({ $0.uploaded == false }) {
            return reverseInterviews[index]
        }
        
        return createInterview()
    }
    
    func updateInterview(fromInterview interview: Interview, interviewUpdate: InterviewUpdate) {
        self.updateInterview(fromIdentifier: interview.identifier, interviewUpdate: interviewUpdate)
    }
    
    func updateInterview(fromIdentifier identifier: String, interviewUpdate: InterviewUpdate) {
        var interviewsArray = interviews.value
        if let index = interviewsArray.indexOf({ $0.identifier == identifier }) {
            let oldInterview = interviewsArray[index]
            let newInterview = Interview(interview: oldInterview, interviewUpdate: interviewUpdate)
            interviewsArray.removeAtIndex(index)
            interviewsArray.append(newInterview)
            interviews.value = interviewsArray.sort({ $0.creationDate.compare($1.creationDate) == NSComparisonResult.OrderedAscending })
            
            print("Updated interview \(newInterview)")
        }
    }
    
    // MARK: Persistence
    
    func archiveToDisk() {
//        let interviewsDict = interviews.map { $0.encode() }
//        
//        if let filePath = persistentFilePath() {
//            NSKeyedArchiver.archiveRootObject(interviewsDict, toFile: filePath)
//        }
    }
    
    func unarchiveFromDisk() {
//        if let
//            path = persistentFilePath(),
//            interviewsDict = NSKeyedUnarchiver.unarchiveObjectWithFile(path),
//            interviews: [Interview] = decode(interviewsDict) {
//            self.interviews = interviews
//        }
    }
    
    private func persistentFilePath() -> String? {
        let basePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first as NSString?
        return basePath?.stringByAppendingPathComponent(archiveFileName)
    }
    
}
