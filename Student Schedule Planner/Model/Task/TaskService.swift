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
    private var reminderTime = [0, 0] //First index is hours, second is minutes
    private var reminderDate = Date()
    private var dateOrTime = 0 //0 means time was selected, non zero means date was selected
    private var hideReminder = true
    //If the user does cares about time conflicts between tasks
    private var checkForTimeConflict = true

    let realm =  try! Realm()
    init() {
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
    func getDateSelected() -> Date {
        return dateSelected
    }
    
    func setDateSelected(date: Date) {
        dateSelected = date
    }
    
    //MARK: - reminderTime
    func getReminderTime() -> [Int] {
        return reminderTime
    }
    
    func setReminderTime(_ time: [Int]) {
        reminderTime = time
    }
    
    //MARK: - reminderDate
    func getReminderDate() -> Date {
        return reminderDate
    }
    
    func setReminderDate(date: Date) {
        reminderDate = date
    }
    
    //MARK: - dateOrTime
    func getDateOrTime() -> Int {
        return dateOrTime
    }
    
    func setDateOrTime(scIndex: Int) {
        dateOrTime = scIndex
    }
    //MARK: - hideReminder
    func getHideReminder() -> Bool {
        return hideReminder
    }
    
    func setHideReminder(bool: Bool) {
        hideReminder = bool
    }
    
    //MARK: - checkForTimeConflict
    func getCheckForTimeConflict() -> Bool {
        return checkForTimeConflict
    }
    
    func setCheckForTimeConflict(bool: Bool) {
        checkForTimeConflict = bool
    }
    
    //MARK: - ReminderString
    func setupReminderString() -> String {
        if TaskService.shared.getDateOrTime() == 0 {
            let reminderTime = TaskService.shared.getReminderTime()
            return formatReminderString(reminderTime: reminderTime)
        } else {
            let date = formatDate(from: TaskService.shared.getReminderDate())
            return "\(date)"
        }
    }
    
    func setupReminderString(task: Task) -> String {
        if task.reminder {
            if task.dateOrTime == 0 {
                let reminderTime: [Int] = [task.reminderTime[0], task.reminderTime[1]]
                return formatReminderString(reminderTime: reminderTime)
            } else {
                let date = formatDate(from: task.reminderDate)
                return "Reminder: \(date)"
            }
        } else {
            return ""
        }
    }
    
    func formatReminderString(reminderTime: [Int]) -> String{
        let hourString = reminderTime[0] == 1 ? "Hour" : "Hours"
        if reminderTime == [0,0] {
            return "Reminder: When Task Starts"
        } else {
            return "Reminder: \(reminderTime[0]) \(hourString), \(reminderTime[1]) min before"
        }
    }
    
    func formatDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMM d, h:mm a"
        let date = dateFormatter.string(from: date)
        return date
    }
}
