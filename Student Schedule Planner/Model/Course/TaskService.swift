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
    private var checkForTimeConflict = true //If the user does cares about time conflicts between tasks
    private var startTime = Date()
    private var endTime = Date().addingTimeInterval(3600)
    private var isClassType = false
    
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
        tasks = realm.objects(Task.self).filter("startDate BETWEEN %@", [dateSelected, endOfDay]).sorted(byKeyPath: "startDate", ascending: true)
    }
    
    //MARK: - tasks
    func getTasks() -> Results<Task>?{
        return tasks
    }
    
    func getTask(atIndex index: Int) -> Task?{
        return tasks?[index]
    }
    
    func updateTasks() {
        tasks = realm.objects(Task.self).sorted(byKeyPath: "startDate", ascending: false)
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
    
    //MARK: - startTime and endTime
    func getStartTime() -> Date {
        return startTime
    }
    
    func setStartTime(time: Date){
        startTime = time
    }
    
    func getEndTime() -> Date {
        return endTime
    }
    
    func setEndTime(time: Date){
        endTime = time
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
    
    func setupReminderString(dateOrTime: Int, reminderTime: [Int], reminderDate: Date) -> String {
        self.dateOrTime = dateOrTime
        self.reminderTime = reminderTime
        self.reminderDate = reminderDate
        if dateOrTime == 0 {
            return formatReminderString(reminderTime: reminderTime)
        } else {
            let date = formatDate(from: reminderDate)
            return "\(date)"
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
        print("Format Date \(date)")
        let date = dateFormatter.string(from: date)
        return date
    }
    
    //MARK: - TASKS
    func makeTasks(forClass theClass: SingleClass) {
        let startDate = Calendar.current.startOfDay(for: theClass.startDate)
        var dayIncrementor = startDate
        let endDate = Calendar.current.startOfDay(for: theClass.endDate)
        var skipDates = 0
        
        while dayIncrementor < endDate {
            if theClass.classDays[dayIncrementor.dayNumberOfWeek()! - 1] == 1 {
                let course = AllCoursesService.shared.getSelectedCourse()
                let task = Task()
                task.title = "\(course?.title ?? "") \(theClass.subType)"
                task.dateOrTime = 0
                task.startDate = theClass.startTime.addingTimeInterval(dayIncrementor.timeIntervalSince(startDate))
                task.endDate = theClass.endTime.addingTimeInterval(dayIncrementor.timeIntervalSince(startDate))
                task.reminder = theClass.reminder
                task.reminderTime = theClass.reminderTime
                task.location = theClass.location
                task.courseId = course?.id ?? ""
                task.type = theClass.type
                task.summativeId = theClass.id
                task.color = course?.color ?? 0
                
                switch theClass.repeats {
                case "2 Weeks":
                    if skipDates == 0 {
                        realm.add(task, update: .modified)
                        scheduleNotification(forTask: task)
                        skipDates = 1
                    } else {
                        skipDates = 0
                    }
                case "4 Weeks":
                    if skipDates == 0 {
                        realm.add(task, update: .modified)
                        scheduleNotification(forTask: task)
                        skipDates = 1
                    } else if skipDates < 3{
                        skipDates += 1
                    } else {
                        skipDates = 0
                    }
                default:
                    realm.add(task, update: .modified)
                    scheduleNotification(forTask: task)
                }
            }
            dayIncrementor.addTimeInterval(86400)
        }
    }
    
    func makeTask(forQuiz quiz: Quiz) {
        let course = AllCoursesService.shared.getSelectedCourse()
        let task = Task()
        task.title = ("\(course?.title ?? "") Quiz")
        task.dateOrTime = 0
        task.startDate = quiz.startDate
        task.endDate = quiz.endDate
        task.location = quiz.location
        task.reminder = quiz.reminder
        task.reminderTime[0] = quiz.reminderTime[0]
        task.reminderTime[1] = quiz.reminderTime[1]
        task.reminderDate = quiz.reminderDate
        task.courseId = course?.id ?? ""
        task.type = "quiz"
        task.summativeId = quiz.summativeId
        task.color = course?.color ?? 0
        task.summativeId = quiz.id
        
        scheduleNotification(forTask: task)
        realm.add(task, update: .modified)
    }
    
    func makeTask(forAssignment assignment: Assignment) {
        let course = AllCoursesService.shared.getSelectedCourse()
        let task = Task()
        task.title = assignment.title
        task.dateOrTime = 0
        task.startDate = assignment.dueDate
        task.endDate = assignment.dueDate
        task.reminder = assignment.reminder
        task.reminderTime[0] = assignment.reminderTime[0]
        task.reminderTime[1] = assignment.reminderTime[1]
        task.reminderDate = assignment.reminderDate
        task.courseId = course?.id ?? ""
        task.type = "assignment"
        task.summativeId = assignment.id
        task.color = course?.color ?? 0
        
        scheduleNotification(forTask: task)
        realm.add(task, update: .modified)
    }
    
    func makeTask(forExam exam: Exam) {
        let course = AllCoursesService.shared.getSelectedCourse()
        let task = Task()
        task.title = ("\(course?.title ?? "") Exam")
        task.dateOrTime = 0
        task.startDate = exam.startDate
        task.endDate = exam.endDate
        task.location = exam.location
        task.reminder = exam.reminder
        task.reminderTime[0] = exam.reminderTime[0]
        task.reminderTime[1] = exam.reminderTime[1]
        task.reminderDate = exam.reminderDate
        task.courseId = course?.id ?? ""
        task.type = "exam"
        task.color = course?.color ?? 0
        task.summativeId = exam.id
        
        scheduleNotification(forTask: task)
        realm.add(task, update: .modified)
    }
    
    func updateTasks(forClass theClass: SingleClass) {
        deleteTasks(forClass: theClass)
        makeTasks(forClass: theClass)
    }
    
    func updateTasks(forQuiz quiz: Quiz) {
        
        let taskToUpdate = realm.objects(Task.self).filter("summativeId == %@", quiz.id).first
        taskToUpdate?.dateOrTime = quiz.dateOrTime
        taskToUpdate?.startDate = quiz.startDate
        taskToUpdate?.endDate = quiz.endDate
        taskToUpdate?.location = quiz.location
        taskToUpdate?.reminder = quiz.reminder
        taskToUpdate?.reminderTime[0] = quiz.reminderTime[0]
        taskToUpdate?.reminderTime[1] = quiz.reminderTime[1]
        taskToUpdate?.reminderDate = quiz.reminderDate
        
        if let taskToUpdate = taskToUpdate {
            scheduleNotification(forTask: taskToUpdate)
        }
    }
    
    func updateTasks(forAssignment assignment: Assignment) {
        let taskToUpdate = realm.objects(Task.self).filter("summativeId == %@", assignment.id).first
        taskToUpdate?.dateOrTime = assignment.dateOrTime
        taskToUpdate?.title = assignment.title
        taskToUpdate?.startDate = assignment.dueDate
        taskToUpdate?.endDate = assignment.dueDate
        taskToUpdate?.reminder = assignment.reminder
        taskToUpdate?.reminderTime[0] = assignment.reminderTime[0]
        taskToUpdate?.reminderTime[1] = assignment.reminderTime[1]
        taskToUpdate?.reminderDate = assignment.reminderDate
        
        if let taskToUpdate = taskToUpdate {
            scheduleNotification(forTask: taskToUpdate)
        }
    }
    
    func updateTasks(forExam exam: Exam) {
        let taskToUpdate = realm.objects(Task.self).filter("summativeId == %@", exam.id).first
        taskToUpdate?.dateOrTime = exam.dateOrTime
        taskToUpdate?.startDate = exam.startDate
        taskToUpdate?.endDate = exam.endDate
        taskToUpdate?.location = exam.location
        taskToUpdate?.reminder = exam.reminder
        taskToUpdate?.reminderTime[0] = exam.reminderTime[0]
        taskToUpdate?.reminderTime[1] = exam.reminderTime[1]
        taskToUpdate?.reminderDate = exam.reminderDate
        
        if let taskToUpdate = taskToUpdate {
            scheduleNotification(forTask: taskToUpdate)
        }
    }
    
    func deleteTasks(forClass theClass: SingleClass) {
        let tasksToDelete = realm.objects(Task.self).filter("summativeId == %@", theClass.id)
        let center = UNUserNotificationCenter.current()
        
        for task in tasksToDelete {
            center.removePendingNotificationRequests(withIdentifiers: [task.id])
            realm.delete(task)
        }
    }
    
    func deleteTasks(forQuiz quiz: Quiz) {
        let taskToDelete = realm.objects(Task.self).filter("summativeId == %@", quiz.id).first
        
        if let taskToDelete = taskToDelete {
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [taskToDelete.id])
            realm.delete(taskToDelete)
        }
    }
    
    func deleteTasks(forAssigment assignment: Assignment) {
        let taskToDelete = realm.objects(Task.self).filter("summativeId == %@", assignment.id).first
        
        if let taskToDelete = taskToDelete {
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [taskToDelete.id])
            realm.delete(taskToDelete)
        }
    }
    
    func deleteTasks(forExam exam: Exam) {
        let taskToDelete = realm.objects(Task.self).filter("summativeId == %@", exam.id).first
        
        if let taskToDelete = taskToDelete {
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [taskToDelete.id])
            realm.delete(taskToDelete)
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
        center.removePendingNotificationRequests(withIdentifiers: [task.id])
        
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
        
        if task.title != "" {
            content.title = task.title
        } else {
            content.title = "Untitled"
        }
        
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: task.id, content: content, trigger: trigger)
        center.add(request)
    }
    //MARK: - Color
    func getColor(colorAsInt color: Int) -> UIColor {
        
        switch color {
        case 0:
            return .alizarin
        case 1:
            return .carrot
        case 2:
            return .sunflower
        case 3:
            return .emerald
        case 4:
            return .turquoise
        case 5:
            return .riverBlue
        case 6:
            return .midnightBlue
        case 7:
            return .amethyst
        default:
            return .clear
        }
    }
}

