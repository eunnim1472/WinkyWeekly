//
//  StudySubject+CoreDataProperties.swift
//  WinkyWeeklyApp
//
//  Created by 김가은 on 5/22/25.
//
//

import Foundation
import CoreData


extension StudySubject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudySubject> {
        return NSFetchRequest<StudySubject>(entityName: "StudySubject")
    }

    @NSManaged public var colors: NSObject?
    @NSManaged public var createdAt: Date?
    @NSManaged public var name: String?
    @NSManaged public var primaryColorHex: NSObject?
    @NSManaged public var sortIndex: Int64
    @NSManaged public var studyBlocks: StudyBlock?
    @NSManaged public var studyLogs: StudyLog?

}

extension StudySubject : Identifiable {

}
