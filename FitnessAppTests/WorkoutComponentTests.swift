//
//  WorkoutComponentTests.swift
//  FitnessAppTests
//
//  Created by Archael dela Rosa on 5/4/23.
//

import XCTest
@testable import FitnessApp

final class WorkoutComponentTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWorkoutComponentsCreationAndRemoval() throws {
        // Test Variables
        let testDate = Date()
        let testLabel = "Test Workout"
        // Workout
        let workout = WorkoutManager.shared.createWorkout(date: testDate, label: testLabel)
        assert(workout.date == testDate)
        assert(workout.label == testLabel)
        
        // Set 1
        let set1 = workout.createSet(name: "TestSet1")
        assert(workout.sets.count == 1) // Confirm Added to Workout.Sets
        assert(set1.workoutID == workout.id)
        assert(set1.index == 0)
        // Set 1: Rep 1
        let set1rep1 = set1.createRep()
        assert(set1.reps.count == 1) // Confirm Added to Set.Reps
        assert(set1rep1.setID == set1.id)
        assert(set1rep1.index == 0)
        // Set 1: Rep 2
        let set1rep2 = set1.createRep()
        assert(set1.reps.count == 2) // Confirm Added to Set.Reps
        assert(set1rep2.setID == set1.id)
        assert(set1rep2.index == 1)
        
        // Set 2
        let set2 = workout.createSet(name: "TestSet2")
        assert(workout.sets.count == 2) // Confirm Added to Workout.Sets
        assert(set2.workoutID == workout.id)
        assert(set2.index == 1)
        // Set 2: Rep 1
        let set2rep1 = set2.createRep()
        assert(set2.reps.count == 1) // Confirm Added to Set.Reps
        assert(set2rep1.setID == set2.id)
        assert(set2rep1.index == 0)
        // Set 2: Rep 2
        let set2rep2 = set2.createRep()
        assert(set2.reps.count == 2) // Confirm Added to Set.Reps
        assert(set2rep2.setID == set2.id)
        assert(set2rep2.index == 1)
        
        // Remove Set2Rep1
        let removeSet2Rep1 = set2.removeRep(index: 0)
        assert(removeSet2Rep1)
        assert(set2.reps.count == 1)
        let removeOOBGreater = set2.removeRep(index: 10)
        assert(removeOOBGreater == false)
        let removeOOBLesser = set2.removeRep(index: -1)
        assert(removeOOBLesser == false)
        
        // Remove WorkoutSet2
        let removeWorkoutSet2 = workout.removeSet(index: 1)
        assert(removeWorkoutSet2)
        assert(workout.sets.count == 1)
        let removeWorkoutOOBGreater = workout.removeSet(index: 10)
        assert(removeWorkoutOOBGreater == false)
        let removeWorkoutOOBLesser = workout.removeSet(index: -1)
        assert(removeWorkoutOOBLesser == false)
    }
    
    func testWorkoutComponentsFetching() throws {
        let date = Date()
        let label = "Test Workout"
        // Create
        let workout = WorkoutManager.shared.createWorkout(date: date, label: label)
        _ = workout.notes?.updateNotes("Hello")
        _ = workout.notes?.updateRating(9)
        let set = workout.createSet(name: "TestSet")
        let rep = set.createRep()
        
        // Fetch
        let confirmWorkout = WorkoutManager.shared.fetchWorkout(date: date, label: label)
        assert(confirmWorkout.id == workout.id)
        assert(confirmWorkout.sets.count == 1)
        let confirmSet = confirmWorkout.sets[0]
        assert(confirmSet.id == set.id)
        assert(confirmSet.reps.count == 1)
        let confirmRep = confirmSet.reps[0]
        assert(confirmRep.id == rep.id)
    }
    
    func testWorkoutDeletion() throws {
        // TODO Test entities and sub entitites(Set,Reps,Notes) deleted
    }
    
    func testWorkoutChanges() throws {
        let workout = WorkoutManager.shared.createWorkout(date: Date(), label: "")
        // MARK: - Set as Complete
        assert(!workout.isCompleted)
        workout.setAsCompleted()
        assert(workout.isCompleted)
    }
    
    func testWorkoutNotesChanges() throws {
        let workout = WorkoutManager.shared.createWorkout(date: Date(), label: "")
        // MARK: - Creation
        assert(workout.notes?.workoutID == workout.id)
        let notes = workout.createNotes()
        assert(notes.workoutID == workout.id)
        
        // MARK: - Update Notes (Okay Notes)
        let testString = "test."
        assert(notes.updateNotes(testString) == true)
        assert(notes.notes == testString)
        
        // MARK: - Update Notes (Illegal Character Limit)
        let beyondCharacterLimit = "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"
        assert(notes.updateNotes(beyondCharacterLimit) == false)
        assert(notes.notes != beyondCharacterLimit)
        
        // MARK: - Performance (Okay)
        let rating = 5
        assert(notes.updateRating(rating))
        assert(notes.performanceRating == rating)
        
        // MARK: - Performance (Under Min)
        let ratingNegitive = -1
        assert(notes.updateRating(ratingNegitive) != true)
        assert(notes.performanceRating != ratingNegitive)
        
        // MARK: - Performance (Over Max)
        let ratingGreater = 11
        assert(notes.updateRating(ratingGreater) != true)
        assert(notes.performanceRating != ratingGreater)
    }
    
    func testSetMovement() throws {
        let workout = WorkoutManager.shared.createWorkout(date: Date(), label: "Test Workout")
        // Sets
        let set1 = workout.createSet(name: "TestSet1")
        assert(set1.index == 0)
        let set2 = workout.createSet(name: "TestSet2")
        assert(set2.index == 1)
        let set3 = workout.createSet(name: "TestSet3")
        assert(set3.index == 2)
        
        // Rearrange Back
        assert(workout.moveSet(fromIndex: 2, toIndex: 0))
        assert(workout.sets[0].name == "TestSet3")
        assert(workout.sets[1].name == "TestSet1")
        assert(workout.sets[2].name == "TestSet2")
        assert(set1.index == 1)
        assert(set2.index == 2)
        assert(set3.index == 0)
        
        // Rearrange Forward
        assert(workout.moveSet(fromIndex: 1, toIndex: 2))
        assert(workout.sets[0].name == "TestSet3")
        assert(workout.sets[1].name == "TestSet2")
        assert(workout.sets[2].name == "TestSet1")
        assert(set1.index == 2)
        assert(set2.index == 1)
        assert(set3.index == 0)
        
        // Rearrange Same
        assert(workout.moveSet(fromIndex: 1, toIndex: 1) == false)
        // Confirm unchanged on Bounds Error
        assert(workout.sets[0].name == "TestSet3")
        assert(workout.sets[1].name == "TestSet2")
        assert(workout.sets[2].name == "TestSet1")
        assert(set1.index == 2)
        assert(set2.index == 1)
        assert(set3.index == 0)
        
        // Rearrange Out of Bounds
        let toOOBLesser = workout.moveSet(fromIndex: 1, toIndex: -1)
        assert(toOOBLesser == false)
        let toOOBGreater = workout.moveSet(fromIndex: 0, toIndex: 50)
        assert(toOOBGreater == false)
        let fromOOBLesser = workout.moveSet(fromIndex: -1, toIndex: 1)
        assert(fromOOBLesser == false)
        let fromOOBGreater = workout.moveSet(fromIndex: 20, toIndex: 0)
        assert(fromOOBGreater == false)
    }
    
    func testRepMovementAndChanges() throws {
        let workout = WorkoutManager.shared.createWorkout(date: Date(), label: "Test Workout")
        let set = workout.createSet(name: "TestSet1")
        // Reps
        let rep1 = set.createRep()
        rep1.update(weight: 10, reps: 10)
        assert(rep1.index == 0)
        let rep2 = set.createRep()
        rep2.update(weight: 20, reps: 20)
        assert(rep2.index == 1)
        let rep3 = set.createRep()
        rep3.update(weight: 30, reps: 30)
        assert(rep3.index == 2)
        
        // Rearrange Back
        assert(set.moveRep(fromIndex: 2, toIndex: 0))
        assert(set.reps[0].reps == 30)
        assert(set.reps[1].reps == 10)
        assert(set.reps[2].reps == 20)
        assert(rep1.index == 1)
        assert(rep2.index == 2)
        assert(rep3.index == 0)
        
        // Rearrange Forward
        assert(set.moveRep(fromIndex: 1, toIndex: 2))
        assert(set.reps[0].reps == 30)
        assert(set.reps[1].reps == 20)
        assert(set.reps[2].reps == 10)
        assert(rep1.index == 2)
        assert(rep2.index == 1)
        assert(rep3.index == 0)
        
        // Rearrange Same
        assert(set.moveRep(fromIndex: 1, toIndex: 1) == false)
        assert(set.reps[0].reps == 30)
        assert(set.reps[1].reps == 20)
        assert(set.reps[2].reps == 10)
        assert(rep1.index == 2)
        assert(rep2.index == 1)
        assert(rep3.index == 0)
        
        // Rearrange Out of Bounds
        let toOOBLesser = set.moveRep(fromIndex: 1, toIndex: -1)
        assert(toOOBLesser == false)
        let toOOBGreater = set.moveRep(fromIndex: 0, toIndex: 50)
        assert(toOOBGreater == false)
        let fromOOBLesser = set.moveRep(fromIndex: -1, toIndex: 1)
        assert(fromOOBLesser == false)
        let fromOOBGreater = set.moveRep(fromIndex: 20, toIndex: 0)
        assert(fromOOBGreater == false)
    }
    
    func testSetChanges() throws {
        let workout = WorkoutManager.shared.createWorkout(date: Date(), label: "Test Workout")
        let set = workout.createSet(name: "TestSet1")
        // Label
        assert(set.name == "TestSet1")
        set.updateLabel(text: "TestTest")
        assert(set.name == "TestTest")
        
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
