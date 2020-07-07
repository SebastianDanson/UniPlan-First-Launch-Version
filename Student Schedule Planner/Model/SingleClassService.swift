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
    
    private var startTime = Date() //Date of first cass
    private var endTime = Date() //Date of last cass
    private var startDate = Date() //Start time of each class
    private var endDate = Date() //End time of each class
    
    private var type = ClassType.Class //Type of class - lab, tutorial, lecture, etc
    private var repeats = "Never" //If the class repeats
    private var reminder = false
    private var classIndex: Int? //index of selected Class
    
    static let shared = SingleClassService()
    
    private init(){}
    
    //MARK: - Class Days
    func getClassDays() -> Array<Int> {
        return classDays
    }
    
    func setClassDay(day: Int) {
        classDays[day] = classDays[day] == 0 ? 1:0
    }
    
    func resetClassDays() {
        classDays = [0, 0, 0, 0, 0, 0, 0]
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
    
    
    func setStartTime(time: Date) {
        startTime = time
    }
    
    //MARK: - End Time
    func getEndTime() -> Date{
        return endTime
    }
    
    func setEndTime(time: Date) {
        endTime = time
    }
    
    //MARK: - startDate
    func getStartDate() -> Date{
        return startDate
    }
    
    func setStartDate(date: Date) {
        startDate = date
    }
    
    //MARK: - endDate
    func getEndDate() -> Date{
        return endDate
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
    
    //sets a string version of the class type
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
    
    //MARK: - Reminder
    func getReminder() -> Bool {
        return reminder
    }
    
    func setReminder(_ bool: Bool) {
        reminder = bool
    }
    
    //MARK: - classIndex
    func getClassIndex() -> Int? {
        return classIndex
    }
    
    func setClassIndex(index: Int?) {
        classIndex = index
    }
}
