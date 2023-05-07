//
//  WorkoutSet.swift
//  FitnessApp
//
//  Created by Archael dela Rosa on 5/4/23.
//

import Foundation

class WorkoutSet: ObservableObject {
    private let entity: SetEntity
    
    @Published var id: UUID
    @Published var name: String
    @Published var index: Int
    @Published var workoutID: UUID
    @Published var reps: [WorkoutRep] = []
    
    
    
    init(entity: SetEntity) {
        self.entity = entity
        self.id = entity.id!
        self.name = entity.name ?? ""
        self.index = Int(entity.index)
        self.workoutID = entity.workoutID!
        loadReps()
    }
    
    func updateLabel(text: String) {
        if (text == name) {return}
        entity.name = text
        name = text
    }
}


// MARK: - Rep Management
extension WorkoutSet {
    
    private func loadReps() {
        let predicate = NSPredicate(format: "setID == %@", self.id as CVarArg)
        let data: [RepEntity] = CoreDataManager.shared.fetchEntities(RepEntity.self, predicate: predicate)
        for entity in data.sorted(by: {$0.index < $1.index}) { // For Each (Sort by index)
            let rep = WorkoutRep(entity: entity) // Create Class
            addRep(rep: rep) // Add to List
        }
    }
    
    private func addRep(rep: WorkoutRep) {
        reps.append(rep)
    }
    
    func createRep() -> WorkoutRep {
        // Create Entity
        let entity: RepEntity = CoreDataManager.shared.createEntity(RepEntity.self)
        entity.id = UUID()
        entity.reps = 0
        entity.weight = 0.0
        entity.isCompleted = false
        entity.index = Int16(reps.count)
        entity.setID = self.id
        
        let rep = WorkoutRep(entity: entity) // Create
        addRep(rep: rep) // Add to List
        return rep
    }
    
    func moveRep(fromIndex: Int, toIndex: Int) -> Bool {
        if !reps.rearrange(fromIndex: fromIndex, toIndex: toIndex) {
            print("Unable to move reps from \(fromIndex) to \(toIndex)")
            return false
        }
        var index = 0
        for rep in reps {
            rep.index = index
            index += 1
        }
        return true
    }
    
    func delete() {
        CoreDataManager.shared.deleteEntity(entity: self.entity) // Delete Entity
        for rep in reps { // Delete Reps
            rep.delete()
        }
        reps.removeAll()
    }
    
    func removeRep(index: Int) -> Bool {
        guard reps.indices.contains(index) else {
            print("Can not remove set. Index \(index) Out of Bounds")
            return false
        }
        let rep = reps.remove(at: index)
        rep.delete()
        return true
    }
}
