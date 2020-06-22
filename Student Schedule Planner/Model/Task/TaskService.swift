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
        if dateOrTime == 0 {
            return formatReminderString(reminderTime: reminderTime)
        } else {
            let date = formatDate(from: reminderDate)
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
                return "\(date)"
            }
        } else {
            return ""
        }
    }
    
    func formatReminderString(reminderTime: [Int]) -> String{
        let hourString = reminderTime[0] == 1 ? "Hour" : "Hours"
        if reminderTime == [0,0] {
            return "When Task Starts"
        } else {
            return "\(reminderTime[0]) \(hourString), \(reminderTime[1]) min before"
        }
    }
    
    func formatDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMM d, h:mm a"
        let date = dateFormatter.string(from: date)
        return date
    }
    
    //MARK: - TASKS
    func makeTasks(forClass theClass: SingleClass) {
        let course = AllCoursesService.shared.getSelectedCourse()
        var startDate = Calendar.current.startOfDay(for: course?.startDate ?? Date())
        var dayIncrementor = startDate
        var endDate = Calendar.current.startOfDay(for: course?.endDate ?? Date())
        
        while dayIncrementor < endDate {
            if theClass.classDays[dayIncrementor.dayNumberOfWeek()! - 1] == 1 {
                let task = Task()
                task.title = "\(AllCoursesService.shared.getSelectedCourse()?.title) Class" ?? ""
                task.dateOrTime = 0
                task.startDate = theClass.startTime.addingTimeInterval(dayIncrementor.timeIntervalSince(startDate))
                task.endDate = theClass.endTime.addingTimeInterval(dayIncrementor.timeIntervalSince(startDate))
                task.reminder = theClass.reminder
                task.reminderTime = theClass.reminderTime
                task.location = theClass.location
                
                realm.add(task)
            }
            dayIncrementor.addTimeInterval(86400)
        }
    }
    
    func makeTask(forQuiz quiz: Quiz) {
        let task = Task()
        task.title = ("\(AllCoursesService.shared.getSelectedCourse()?.title) Quiz") ?? ""
        task.dateOrTime = 0
        task.startDate = quiz.startDate
        task.endDate = quiz.endTime
        
        scheduleNotification(forTask: task)
        
        realm.add(task)
    }
    
    
    func updateTasks(forClass theClass: SingleClass) {
        deleteTasks()
        makeTasks(forClass: theClass)
    }
    
    func deleteTasks() {
        var course = AllCoursesService.shared.getSelectedCourse()
        let tasksToUpdate = realm.objects(Task.self).filter("title == %@ AND location == %@", course?.title, SingleClassService.shared.getInitialLocation())
        
        for task in tasksToUpdate {
            realm.delete(task)
        }
    }
    
    //MARK: - Push notification methods
    @objc func askToSendNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {_,_ in })
    }
    
    @objc func scheduleNotification(forTask task: Task) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        
        var dateComponents = DateComponents()
        let units: Set<Calendar.Component> = [.nanosecond, .second,.minute, .hour, .day, .month, .year]
        
        //If user specified 'time before' the date for the reminder
        if task.dateOrTime == 0 {
            let reminderTime = task.reminderTime
            var comps = Calendar.current.dateComponents(units, from: task.startDate)
            comps.second = 0 //ignores seconds -> reminder happens when the specified minute occurs
            dateComponents = comps
            if let hours = dateComponents.hour, let minutes = dateComponents.minute{
                dateComponents.hour = hours - reminderTime[0]
                dateComponents.minute = minutes - reminderTime[1]
                
                if reminderTime[0] == 0, reminderTime[1] == 0 {
                    content.body = "Your task starts now"
                } else  {
                    content.body = "Your task will start in \(reminderTime[0]) hour(s) and \(reminderTime[1]) minutes"
                }
            }
        } else {
            var comps = Calendar.current.dateComponents(units, from: task.reminderDate)
            comps.nanosecond = 0
            comps.second = 0
            dateComponents = comps
            let date = formatDate(from: task.startDate)
            content.body = "Your task will start on \(date)"
        }
        
        content.title = task.title
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
}
