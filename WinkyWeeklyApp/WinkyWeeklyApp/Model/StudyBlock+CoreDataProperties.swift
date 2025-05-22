//
//  StudyBlock+CoreDataProperties.swift
//  WinkyWeeklyApp
//
//  Created by 김가은 on 5/22/25.
//
//

import Foundation
import CoreData


extension StudyBlock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudyBlock> {
        return NSFetchRequest<StudyBlock>(entityName: "StudyBlock")
    }

    @NSManaged public var day: Int32
    @NSManaged public var startTime: Date?
    @NSManaged public var endTime: Date?
    @NSManaged public var subjects: Subject?
    @NSManaged public var plans: StudyPlan?

}

extension StudyBlock : Identifiable {

}
