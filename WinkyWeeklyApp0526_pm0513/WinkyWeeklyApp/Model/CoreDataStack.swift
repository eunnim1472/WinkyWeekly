//
//  CoreDataStack.swift
//  WinkyWeeklyApp
//
//  Created by 김가은 on 5/22/25.
//
import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WinkyWeeklyApp") // ← 📛 반드시 .xcdatamodeld 이름과 일치
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data Store 로딩 실패: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // ✅ 테스트 전용 인메모리 설정
    static func makeTestContainer() -> NSManagedObjectContext {
        let container = NSPersistentContainer(name: "WinkyWeeklyApp")
        let desc = NSPersistentStoreDescription()
        desc.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [desc]
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("In-memory Core Data setup failed: \(error)")
            }
        }
        return container.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ Core Data 저장 실패:", error)
            }
        }
    }
}
