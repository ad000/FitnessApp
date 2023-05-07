//
//  WorkoutManager.swift
//  FitnessApp
//
//  Created by Archael dela Rosa on 5/4/23.
//

import Foundation

class WorkoutManager: ObservableObject {
    static let shared = WorkoutManager()
    
    init() {}
    
    func fetchWorkout(date: Date, label: String) -> Workout {
        let predicate = NSPredicate(format: "date == %@ AND label == %@", date as CVarArg, label)
        let data:[WorkoutEntity] = CoreDataManager.shared.fetchEntities(WorkoutEntity.self, predicate: predicate)
        guard let entity = data.first else {
            print ("No Workout at data:\(date), label\(label)")
            return createWorkout(date: date, label: label)
        }
        return Workout(entity: entity)
    }
    
    func createWorkout(date: Date, label: String) -> Workout {
        print("Creating Workout: data:\(date), label\(label)")
        let entity = CoreDataManager.shared.createEntity(WorkoutEntity.self)
        entity.id = UUID()
        entity.date = date
        entity.label = label
        entity.isCompleted = false
        
        return Workout(entity: entity)
    }
    
    func deleteWorkout(workout: Workout) {
        workout.delete()
    }
}
