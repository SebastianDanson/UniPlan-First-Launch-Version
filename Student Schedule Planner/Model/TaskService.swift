//
//  TaskService.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-04.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import Foundation

class TaskService {
    
    private var tasks = [Task]()
    
    static let shared = TaskService()
    private init() {}
    
    //Create new Task
    func createTask(task: Task) {
        tasks.append(task)
    }
    
    //Update Tasks
    func updateTasks(index: Int, task: Task){
        tasks[index] = task
    }
    
    //Get # of Tasks
    func getCount() -> Int {
        return tasks.count
    }
    
    //Get a specific Task
    func getTask(index: Int) -> Task {
        return tasks[index]
    }
    
    //Get the list of Tasks
    func listOfTasks() -> [Task] {
        return tasks
    }
    
    //Delete a Task
    func deleteTask(index: Int) {
        tasks.remove(at: index)
    }
    
    
}
