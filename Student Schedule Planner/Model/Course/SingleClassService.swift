//
//  SingleClassService.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-14.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import Foundation

class SingleClassService {
    
    private var classDays: Array<Int> = [0, 0, 0, 0, 0, 0, 0]
    private var location = ""
    private var startTime = Date()
    private var endTime = Date()
    private var startDate = Date()
    private var endDate = Date()
    private var type = ClassType.Class
    private var repeats = "Never"
    private var reminderTime = [0, 0] //First index is hours, second is minutes
    private var reminder = false
    private var classIndex: Int?
    private var initialLocation = ""
    
    static let shared = SingleClassService()
    
    private init(){}
    
    //MARK: - Class Days
    func getClassDays() -> Array<Int> {
        return classDays
    }
    
    func setClassDay(day: Int) {
        classDays[day] = classDays[day] == 0 ? 1:0
    }
    
    //MARK: - Location
    func getLocation() -> String {
        return location
    }
    
    func setLocation(locationName: String) {
        location = locationName
    }
    
    //MARK: - Repeats
    func getRepeats() -> String {
        return repeats
    }
    
    func setRepeats(every: String) {
        repeats = every
    }
    //MARK: - Start Time
    func getStartTime() -> Date{
        return startTime
    }
    
    func getStartTimeAsString() -> String {
        return formatTime(from: startTime)
    }
    
    func setStartTime(time: Date) {
        startTime = time
    }
    
    //MARK: - End Time
    func getEndTime() -> Date{
        return endTime
    }
    
    func getEndTimeAsString() -> String {
        return formatTime(from: endTime)
    }
    
    func setEndTime(time: Date) {
        endTime = time
    }
    
    //MARK: - Start Date
    func getStartDate() -> Date{
        return startDate
    }
    
    func getStartDateAsString() -> String {
        return formatDate(from:  startDate)
    }
    
    func setStartDate(date: Date) {
        startDate = date
    }
    
    //MARK: - End Date
    func getEndDate() -> Date{
        return endDate
    }
    
    func getEndDateAsString() -> String {
        return formatDate(from: endDate)
    }
    
    func setEndDate(date: Date) {
        endDate = date
    }
    
    //MARK: - Type
    func getType() -> ClassType {
        return type
    }
    
    func setType(classType: ClassType) {
        type = classType
    }
    
    func setTypeAsString(classTypeString: String) {
        switch classTypeString {
        case "Class":
            type = .Class
        case "Lecture":
            type = .Lecture
        case "Lab":
            type = .Lab
        case "Tutorial":
            type = .Tutorial
        case "Seminar":
            type = .Seminar
        case "Study Session":
            type = .StudySession
        default:
            break
        }
    }
    
    //MARK: - reminderTime
    func getReminderTime() -> [Int] {
        return reminderTime
    }
    
    func setReminderTime(_ time: [Int]) {
        reminderTime = time
    }
    
    //MARK: - Reminder
    func getReminder() -> Bool {
        return reminder
    }
    
    func setReminder(_ bool: Bool) {
        reminder = bool
    }
    
    //MARK: - ReminderString
    func setupReminderString() -> String {
        if reminder {
            return formatReminderString(reminderTime: reminderTime)
        } else {
            return "None"
        }
    }
    
    func setupReminderString(theClass: SingleClass) -> String {
        if theClass.reminder {
            let reminderTime: [Int] = [theClass.reminderTime[0], theClass.reminderTime[1]]
            let reminderString = TaskService.shared.formatReminderString(reminderTime: reminderTime).replacingOccurrences(of: "Reminder: ", with: "")
             return reminderString
        } else {
            return "None"
        }
    }
    
    func formatReminderString(reminderTime: [Int]) -> String{
        if reminderTime == [0,0] {
            return "When Class Starts"
        } else {
            return "\(reminderTime[0])h, \(reminderTime[1])m before"
        }
    }
    
    //MARK: - classIndex
    func getClassIndex() -> Int? {
        return classIndex
    }
    func setClassIndex(index: Int?) {
        classIndex = index
    }
    
    //MARK: - initialLocation
    func getInitialLocation() -> String {
        return initialLocation
    }
    
    func setInitialLocation(location: String){
        initialLocation = location
    }
}
