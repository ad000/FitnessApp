//
//  CoreDataManager.swift
//  FitnessApp
//
//  Created by Archael dela Rosa on 5/4/23.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() { }
    
    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    // MARK: - Entity methods
    
    func createEntity<T: NSManagedObject>(_ type: T.Type) -> T {
        let context = persistentContainer.viewContext
        guard let entityName = NSStringFromClass(type).components(separatedBy: ".").last else {
            fatalError("Could not retrieve entity name for class: \(NSStringFromClass(type))")
        }
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            fatalError("Could not retrieve entity description for name: \(entityName)")
        }
        return T(entity: entity, insertInto: context)
    }
    
    func deleteEntity(entity: NSManagedObject) {
        let context = persistentContainer.viewContext
        context.delete(entity)
    }
    
    
    func fetchEntities<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [T] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<T>(entityName: NSStringFromClass(type))
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            let entities = try context.fetch(fetchRequest)
            print("Fetched Entities<\(type)> count: \(entities.count)")
            return entities
        } catch {
            print("Failed to fetch entities: \(error)")
            return []
        }
    }
}
