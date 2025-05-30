//
//  PersistenceController.swift
//  Jibun
//
//  Created by Rahul on 30/05/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "JibunModel")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        let context = container.viewContext

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("❌ Core Data store failed: \(error.localizedDescription)")
            }

            #if DEBUG
            // Use local reference to context instead of self
            PersistenceController.seedSampleDataIfNeeded(context: context)
            #endif
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    /// Static method to seed sample data without using `self`
    private static func seedSampleDataIfNeeded(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        let courseCount = (try? context.count(for: fetchRequest)) ?? 0

        if courseCount == 0 {
            print("🚀 Loading content from JSON files...")
            ContentLoader.shared.populateCoreData(context: context)
        }
    }
}
