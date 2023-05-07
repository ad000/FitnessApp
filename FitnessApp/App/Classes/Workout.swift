//
//  Workout.swift
//  FitnessApp
//
//  Created by Archael dela Rosa on 5/4/23.
//

import Foundation

// MARK: - Workout
class Workout: ObservableObject {
    private let entity: WorkoutEntity
    
    @Published var id: UUID
    @Published var date: Date
    @Published var label: String
    @Published var isCompleted: Bool
    @Published var sets: [WorkoutSet] = []
    @Published var notes: WorkoutNotes?
    
    init(entity: WorkoutEntity) {
        self.entity = entity
        self.id = entity.id!
        self.date = entity.date ?? Date()
        self.label = entity.label ?? ""
        self.isCompleted = entity.isCompleted
        LoadNotes()
        loadSets()
    }
    
    func setAsCompleted() {
        self.entity.isCompleted = true
        isCompleted = true
    }
}

    
// MARK: - Set Management
extension Workout {
    
    private func loadSets() {
        let predicate = NSPredicate(format: "workoutID = %@", self.id as CVarArg)
        let data: [SetEntity] = CoreDataManager.shared.fetchEntities(SetEntity.self, predicate: predicate)
        for entity in data.sorted(by: {$0.index < $1.index}) { // For Each (Sort by index)
            let set = WorkoutSet(entity: entity) // Create Set Class
            addSet(set: set) // Add to List
        }
    }
    
    private func addSet(set: WorkoutSet) {
        sets.append(set)
    }
    
    func createSet(name: String) -> WorkoutSet {
        // Create Entity
        let entity: SetEntity = CoreDataManager.shared.createEntity(SetEntity.self)
        entity.id = UUID()
        entity.index = Int16(sets.count)
        entity.name = name
        entity.workoutID = self.id
        
        let set = WorkoutSet(entity: entity) // Create Set
        addSet(set: set) // Add to List
        return set
    }
    
    func moveSet(fromIndex: Int, toIndex: Int) -> Bool {
        if !sets.rearrange(fromIndex: fromIndex, toIndex: toIndex) {
            print("Unable to move sets from \(fromIndex) to \(toIndex)")
            return false
        }
        var index = 0
        for set in sets {
            set.index = index
            index += 1
        }
        return true
    }
    
    func delete() {
        CoreDataManager.shared.deleteEntity(entity: self.entity) // Delete Entity
        for set in sets { // Delete Sets
            set.delete()
        }
        sets.removeAll()
    }
    
    func removeSet(index: Int) -> Bool {
        guard sets.indices.contains(index) else {
            print("Can not remove set. Index \(index) Out of Bounds")
            return false
        }
        let _ = sets.remove(at: index)
        return true
    }
}


// MARK: - Notes Management
extension Workout {
    
    private func LoadNotes() {
        let predicate = NSPredicate(format: "workoutID == %@", self.id as CVarArg)
        let data: [WorkoutNotesEntity] = CoreDataManager.shared.fetchEntities(WorkoutNotesEntity.self, predicate: predicate)
        if let entity: WorkoutNotesEntity = data.first {
            self.notes = WorkoutNotes(entity: entity) // Attach
        }
        else {
            self.notes = createNotes() // Create
        }
    }
    
    
    func createNotes() -> WorkoutNotes {
        if (self.notes != nil) {
            print("Workout Notes Exists")
            return self.notes!
        }
        // Create Entity
        let entity: WorkoutNotesEntity = CoreDataManager.shared.createEntity(WorkoutNotesEntity.self)
        entity.id = UUID()
        entity.workoutID = self.id
        
        let notes = WorkoutNotes(entity: entity) // Create Set
        self.notes = notes // Attach
        return notes
    }
}
