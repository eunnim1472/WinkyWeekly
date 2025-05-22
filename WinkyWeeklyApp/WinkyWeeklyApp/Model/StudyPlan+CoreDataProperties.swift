//
//  StudyPlan+CoreDataProperties.swift
//  WinkyWeeklyApp
//
//  Created by 김가은 on 5/22/25.
//
//

import Foundation
import CoreData


extension StudyPlan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudyPlan> {
        return NSFetchRequest<StudyPlan>(entityName: "StudyPlan")
    }

    @NSManaged public var title: String?
    @NSManaged public var blocks: StudyBlock?

}

extension StudyPlan : Identifiable {

}
