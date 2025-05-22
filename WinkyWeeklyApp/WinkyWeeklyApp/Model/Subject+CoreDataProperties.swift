//
//  Subject+CoreDataProperties.swift
//  WinkyWeeklyApp
//
//  Created by 김가은 on 5/22/25.
//
//

import Foundation
import CoreData


extension Subject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subject> {
        return NSFetchRequest<Subject>(entityName: "Subject")
    }

    @NSManaged public var name: String?
    @NSManaged public var colors: NSObject?
    @NSManaged public var sortIndex: Int64
    @NSManaged public var createdAt: Date?
    @NSManaged public var primaryColorHex: NSObject?
    @NSManaged public var studyLogs: StudyLog?
    @NSManaged public var studyBlocks: StudyBlock?

}

extension Subject : Identifiable {

}
