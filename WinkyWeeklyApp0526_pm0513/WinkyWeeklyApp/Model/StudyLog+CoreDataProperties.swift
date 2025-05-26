//
//  StudyLog+CoreDataProperties.swift
//  WinkyWeeklyApp
//
//  Created by 김가은 on 5/22/25.
//
//

import Foundation
import CoreData


extension StudyLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudyLog> {
        return NSFetchRequest<StudyLog>(entityName: "StudyLog")
    }

    @NSManaged public var data: Date?
    @NSManaged public var duration: NSObject?
    @NSManaged public var studySubjects: StudySubject?

}

extension StudyLog : Identifiable {

}
