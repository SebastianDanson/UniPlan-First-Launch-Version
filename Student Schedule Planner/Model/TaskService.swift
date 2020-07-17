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
    private var dateOrTime = 0 //0 means time was selected, non zero means date was selected for the reminder
    private var hideReminder = true
    private var checkForTimeConflict = true //If the user does cares about time conflicts between tasks
    private var startTime = Date()
    private var endTime = Date().addingTimeInterval(3600)
    private var isClass = false //If the task is associated with a class
    private var color = UIColor.alizarin
    private var firstDayOfWeek = Date()
    
    let realm =  try! Realm()
    init() {
        updateTasks()
    }
    static let shared = TaskService()
    
    //Loads task for the day selected
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
        if reminderTime == [0,0] {
            return "When It Starts"
        } else {
            return "\(reminderTime[0])h: \(reminderTime[1])m before"
        }
    }
    
    func formatDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMM d, h:mma"
        let date = dateFormatter.string(from: date)
        return date
    }
    
    //MARK: - TASKS
    func makeTasks(forClass theClass: SingleClass) {
        let startDate = Calendar.current.startOfDay(for: theClass.startDate)
        var dayIncrementor = startDate
        let endDate = Calendar.current.startOfDay(for: theClass.endDate.addingTimeInterval(86400))
        var skipDates = 0
        let course = AllCoursesService.shared.getSelectedCourse()
        let color = UIColor.init(red: CGFloat(course?.color[0] ?? 0), green: CGFloat(course?.color[1] ?? 0), blue: CGFloat(course?.color[2] ?? 0), alpha: 1)
        
        var numDays: Int = {
            return (Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: Date()), to: startDate).day ?? 0)
        }()
        while dayIncrementor < endDate {
            if theClass.classDays[dayIncrementor.dayNumberOfWeek()! - 1] == 1 {
                let task = Task()
                task.title = "\(course?.title ?? "") \(theClass.subType)"
                task.dateOrTime = 0
                task.startDate = theClass.startTime.addingTimeInterval(TimeInterval(86400*numDays))
                task.endDate = theClass.endTime.addingTimeInterval(TimeInterval(86400*numDays))
                task.reminder = theClass.reminder
                task.reminderTime = theClass.reminderTime
                task.location = theClass.location
                task.courseId = course?.id ?? ""
                task.type = theClass.type
                task.summativeId = theClass.id
                
                let rgb = color.components
                task.color[0] = Double(rgb.red)
                task.color[1] = Double(rgb.green)
                task.color[2] = Double(rgb.blue)
                
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
            numDays+=1
            dayIncrementor.addTimeInterval(86400)
        }
    }
    
    func makeTasks(forRoutine routine: Routine) {
        let startDate = Calendar.current.startOfDay(for: routine.startDate)
        var dayIncrementor = startDate
        let endDate = Calendar.current.startOfDay(for: routine.endDate.addingTimeInterval(86400))
        var skipDates = 0
        let color = UIColor.init(red: CGFloat(routine.color[0]), green: CGFloat(routine.color[1]), blue: CGFloat(routine.color[2]), alpha: 1)
        
        var numDays: Int = {
            return (Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: Date()), to: startDate).day ?? 0)
        }()
        
        while dayIncrementor < endDate {
            if routine.days[dayIncrementor.dayNumberOfWeek()! - 1] == 1 {
                let task = Task()
                task.title = routine.title
                task.dateOrTime = 0
                task.startDate = routine.startTime.addingTimeInterval(TimeInterval(86400*numDays))
                task.endDate = routine.endTime.addingTimeInterval(TimeInterval(86400*numDays))
                task.reminder = routine.reminder
                task.reminderTime = routine.reminderTime
                task.location = routine.location
                task.summativeId = routine.id
                
                let rgb = color.components
                task.color[0] = Double(rgb.red)
                task.color[1] = Double(rgb.green)
                task.color[2] = Double(rgb.blue)
                
                switch routine.repeats {
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
            numDays+=1
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
        task.color[0] = course?.color[0] ?? 0
        task.color[1] = course?.color[1] ?? 0
        task.color[2] = course?.color[2] ?? 0
        
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
        
        task.color[0] = course?.color[0] ?? 0
        task.color[1] = course?.color[1] ?? 0
        task.color[2] = course?.color[2] ?? 0
        
        
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
        task.color[0] = course?.color[0] ?? 0
        task.color[1] = course?.color[1] ?? 0
        task.color[2] = course?.color[2] ?? 0
        task.summativeId = exam.id
        
        scheduleNotification(forTask: task)
        realm.add(task, update: .modified)
    }
    
    func updateTasks(forClass theClass: SingleClass) {
        deleteTasks(forClass: theClass)
        makeTasks(forClass: theClass)
    }
    
    func updateTasks(forRoutine routine: Routine) {
           deleteTasks(forRoutine: routine)
           makeTasks(forRoutine: routine)
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
        taskToUpdate?.isComplete = quiz.isComplete
        
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
        taskToUpdate?.isComplete = assignment.isComplete

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
        taskToUpdate?.isComplete = exam.isComplete

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
    
    func deleteTasks(forRoutine routine: Routine) {
        let tasksToDelete = realm.objects(Task.self).filter("summativeId == %@", routine.id)
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
    
    func deleteSummativeForTask(taskToDelete: Task, type: String) {
        do {
            try self.realm.write {
                //Deletes task and the summative associated with that task if there is one
                switch taskToDelete.type {
                case "assignment":
                    let assignmentToDelete = realm.objects(Assignment.self).filter("id == %@", taskToDelete.summativeId).first
                    if let assignmentToDelete = assignmentToDelete {
                        realm.delete(assignmentToDelete)
                    }
                case "quiz":
                    let quizToDelete = realm.objects(Quiz.self).filter("id == %@", taskToDelete.summativeId).first
                    if let quizToDelete = quizToDelete {
                        realm.delete(quizToDelete)
                    }
                case "exam":
                    let examToDelete = realm.objects(Exam.self).filter("id == %@", taskToDelete.summativeId).first
                    if let examToDelete = examToDelete {
                        realm.delete(examToDelete)
                    }
                default:
                    break
                }
                deleteNotification(forTask: taskToDelete)
                self.realm.delete(taskToDelete)
            }
            
        } catch {
            print("Error writing task to realm")
        }
    }
    
    func setSummativeIsComplete(task: Task, type: String) {
        do{
            try realm.write {
                task.isComplete = true
                switch task.type {
                case "assignment":
                    let assignmentToComplete = realm.objects(Assignment.self).filter("id == %@", task.summativeId).first
                    if let assignmentToComplete = assignmentToComplete {
                        assignmentToComplete.isComplete = true
                    }
                case "quiz":
                    let quizToComplete = realm.objects(Quiz.self).filter("id == %@", task.summativeId).first
                    if let quizToComplete = quizToComplete {
                        quizToComplete.isComplete = true
                    }
                case "exam":
                    let examToComplete = realm.objects(Exam.self).filter("id == %@", task.summativeId).first
                    if let examToComplete = examToComplete {
                        examToComplete.isComplete = true
                    }
                default:
                    break
                }
            }
        }catch{
            print("Error setting isComplete to tru \(error.localizedDescription)")
        }
    }
    //MARK: - Push notification methods
    @objc func askToSendNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {_,_ in })
    }
    
    func deleteNotification(forTask task: Task){
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [task.id])
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
    
    //MARK: - isClass
    func getIsClass() -> Bool {
        return isClass
    }
    
    func setIsClass(bool: Bool) {
        isClass = bool
    }
    //MARK: - color
    func getColor() -> UIColor {
        return color
    }
    
    func setColor(color: UIColor) {
        self.color = color
    }
    
    //MARK: - firstDayOfWeek
    func getfirstDayOfWeek() -> Date {
        return firstDayOfWeek
    }
    
    func setfirstDayOfWeek(date: Date) {
        print(date)
        firstDayOfWeek = date
    }
}

