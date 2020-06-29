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
        let date = dateFormatter.string(from: date)
        return date
    }
    
    //MARK: - TASKS
    func makeTasks(forClass theClass: SingleClass) {
        let course = AllCoursesService.shared.getSelectedCourse()
        let startDate = Calendar.current.startOfDay(for: course?.startDate ?? Date())
        var dayIncrementor = startDate
        let endDate = Calendar.current.startOfDay(for: course?.endDate ?? Date())
        SingleClassService.shared.setNumClasses(num: (SingleClassService.shared.getNumClasses() + 1))
        
        while dayIncrementor < endDate {
            if theClass.classDays[dayIncrementor.dayNumberOfWeek()! - 1] == 1 {
                let course = AllCoursesService.shared.getSelectedCourse()
                let task = Task()
                task.title = "\(course?.title ?? "") Class"
                task.dateOrTime = 0
                task.startDate = theClass.startTime.addingTimeInterval(dayIncrementor.timeIntervalSince(startDate))
                task.endDate = theClass.endTime.addingTimeInterval(dayIncrementor.timeIntervalSince(startDate))
                task.reminder = theClass.reminder
                task.reminderTime = theClass.reminderTime
                task.location = theClass.location
                task.course = course?.title ?? ""
                task.type = theClass.type
                task.index = SingleClassService.shared.getNumClasses()
                task.color = course?.color ?? 0 
                
                realm.add(task, update: .modified)
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
        task.course = course?.title ?? ""
        task.type = "quiz"
        task.index = QuizService.shared.getNumQuizzes()
        task.color = course?.color ?? 0

        scheduleNotification(forTask: task)
        realm.add(task, update: .modified)
        QuizService.shared.setNumQuizzes(num: (QuizService.shared.getNumQuizzes() + 1))
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
        task.course = course?.title ?? ""
        task.type = "assignment"
        task.index = AssignmentService.shared.getNumAssignments()
        task.color = course?.color ?? 0

        scheduleNotification(forTask: task)
        realm.add(task, update: .modified)
        AssignmentService.shared.setNumAssignments(num: (AssignmentService.shared.getNumAssignments() + 1))
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
        task.course = course?.title ?? ""
        task.type = "exam"
        task.color = course?.color ?? 0
        task.index = ExamService.shared.getNumExams()
        
        scheduleNotification(forTask: task)
        realm.add(task, update: .modified)
        ExamService.shared.setNumExams(num: (ExamService.shared.getNumExams() + 1))
    }
    
    func updateTasks(forClass theClass: SingleClass) {
        deleteTasks(forClass: theClass)
        makeTasks(forClass: theClass)
    }
    
    func updateTasks(forQuiz quiz: Quiz) {
        let course = AllCoursesService.shared.getSelectedCourse()
        let taskToUpdate = realm.objects(Task.self).filter("course == %@ AND type == %@ AND index == %@", course?.title, "quiz", quiz.index).first
        taskToUpdate?.dateOrTime = 0
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
        let course = AllCoursesService.shared.getSelectedCourse()
        let taskToUpdate = realm.objects(Task.self).filter("course == %@ AND type == %@ AND index == %@", course?.title, "assignment", assignment.index).first
        taskToUpdate?.dateOrTime = 0
        taskToUpdate?.startDate = assignment.dueDate
        taskToUpdate?.reminder = assignment.reminder
        taskToUpdate?.reminderTime[0] = assignment.reminderTime[0]
        taskToUpdate?.reminderTime[1] = assignment.reminderTime[1]
        taskToUpdate?.reminderDate = assignment.reminderDate
        
        if let taskToUpdate = taskToUpdate {
            scheduleNotification(forTask: taskToUpdate)
        }
    }
    
    func updateTasks(forExam exam: Exam) {
        let course = AllCoursesService.shared.getSelectedCourse()
        let taskToUpdate = realm.objects(Task.self).filter("course == %@ AND type == %@ AND index == %@", course?.title, "exam", exam.index).first
        taskToUpdate?.dateOrTime = 0
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
        let course = AllCoursesService.shared.getSelectedCourse()
        let tasksToDelete = realm.objects(Task.self).filter("course == %@ AND type == %@ AND index == %@", course?.title, theClass.type, theClass.index)
        
        for task in tasksToDelete {
            realm.delete(task)
        }
    }
    
    func deleteTasks(forQuiz quiz: Quiz) {
        let course = AllCoursesService.shared.getSelectedCourse()
        let taskToDelete = realm.objects(Task.self).filter("course == %@ AND type == %@ AND index == %@", course?.title, "quiz", quiz.index).first
        
        if let taskToDelete = taskToDelete {
            realm.delete(taskToDelete)
        }
    }
    
    func deleteTasks(forAssigment assignment: Assignment) {
        
        let course = AllCoursesService.shared.getSelectedCourse()
        let taskToDelete = realm.objects(Task.self).filter("course == %@ AND type == %@ AND index == %@", course?.title, "assignment" , assignment.index).first
        
        if let taskToDelete = taskToDelete {
            realm.delete(taskToDelete)
        }
    }
    
    func deleteTasks(forExam exam: Exam) {
        let course = AllCoursesService.shared.getSelectedCourse()
        let taskToDelete = realm.objects(Task.self).filter("course == %@ AND type == %@ AND index == %@", course?.title, "exam", exam.index).first
        
        if let taskToDelete = taskToDelete {
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
