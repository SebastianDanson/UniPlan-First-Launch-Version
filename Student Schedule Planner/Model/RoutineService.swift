//
//  RoutineService.swift
//  UniPlan
//
//  Created by Student on 2020-07-12.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import Foundation
import RealmSwift

class RoutineService {
    
    let realm = try! Realm()
    
    private var routines: Results<Routine>?
    private var selectedRoutine: Routine?
    private var routineIndex: Int?
    private var isRoutine = false
    
    static let shared = RoutineService()
    private init() {}
    
    //MARK: - routines
    func getRoutine(atIndex index: Int) -> Routine? {
        updateRoutines()
        return routines?[index]
    }
    
    func getRoutines() -> Results<Routine>? {
        updateRoutines()
        return routines
    }
    
    func updateRoutines() {
        routines = realm.objects(Routine.self)
    }
    
    func getSelectedRoutine() -> Routine? {
        return selectedRoutine
    }
    
    func setSelectedRoutine(routine: Routine?) {
        selectedRoutine = routine
    }
    
    func setRoutineIndex(index: Int?) {
        routineIndex = index
        if let index = index {
            selectedRoutine = routines?[index]
        }
    }
    
    //MARK: - isRoutine
    func getIsRoutine() -> Bool {
        return isRoutine
    }
    
    func setIsRoutine(bool: Bool) {
        isRoutine = bool
    }
    
}
