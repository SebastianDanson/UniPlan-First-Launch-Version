//
//  TaskService.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-06.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import Foundation
import RealmSwift

class TaskService {
    
    private var tasks: Results<Task>?
    private var dateSelected = Date()
    private var taskIndex: Int?
    //If the user does cares about time conflicts between tasks
    private var checkForTimeConflict = true
    
    let realm =  try! Realm()
    
    private init() {
        updateTasks()
    }
    static let shared = TaskService()
    
    func loadTasks(){
        dateSelected = Calendar.current.startOfDay(for: dateSelected)
        let endOfDay: Date = {
            let components = DateComponents(day: 1, second: -1)
            return Calendar.current.date(byAdding: components, to: dateSelected)!
        }()
        tasks = realm.objects(Task.self).filter("startDate BETWEEN %@", [dateSelected, endOfDay])
    }
   //MARK: - tasks
    func getTasks() -> Results<Task>?{
        return tasks
    }
    
    func getTask(atIndex index: Int) -> Task?{
        return tasks?[index]
    }
    func updateTasks() {
          tasks = realm.objects(Task.self)
    }
    
    
    //MARK: - taskIndex
    func getTaskIndex() -> Int? {
        return taskIndex
    }
    func setTaskIndex(index: Int?) {
        taskIndex = index
    }
    
    //MARK: - dateSelected
    func setDateSelected(date: Date) {
        dateSelected = date
    }
    
    func getDateSelected() -> Date {
        return dateSelected
    }
    
    //MARK: - checkForTimeConflict
    func getCheckForTimeConflict() -> Bool {
        return checkForTimeConflict
    }
    
    func setCheckForTimeConflict(bool: Bool) {
        checkForTimeConflict = bool
    }
}
