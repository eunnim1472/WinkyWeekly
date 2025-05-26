//
//  SubjectTests.swift
//  WinkyWeeklyAppTests
//
//  Created by 김가은 on 5/22/25.
//

import XCTest
@testable import WinkyWeeklyApp
import CoreData

final class SubjectTests: XCTestCase {
    
    var context: NSManagedObjectContext!

    override func setUpWithError() throws {
        try super.setUpWithError()

        // ✅ 인메모리 CoreData 설정 (테스트용)
        let container = NSPersistentContainer(name: "WinkyWeeklyApp")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType // 디스크에 저장하지 않고 메모리 상에서만 동작
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ 테스트용 CoreData 설정 실패: \(error)")
            }
        }

        self.context = container.viewContext
    }

    override func tearDownWithError() throws {
        context = nil
        try super.tearDownWithError()
    }

    // ✅ 테스트 함수 예시
    func testCreateSubject() throws {
        let subject = StudySubject(context: context)
        subject.name = "수학"
        subject.createdAt = Date()
        subject.colors = ["#FF5E5E"] as NSObject
        subject.primaryColorHex = "#FF5E5E" as NSObject
        subject.sortIndex = 0

        try context.save()

        // 불러와서 검증
        let request: NSFetchRequest<StudySubject> = StudySubject.fetchRequest()
        let results = try context.fetch(request)

        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.name, "수학")
        XCTAssertEqual(results.first?.colors as? [String], ["#FF5E5E"])
    }
}
