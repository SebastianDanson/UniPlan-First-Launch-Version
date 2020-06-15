//
//  SingleClassService.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-14.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import Foundation
import RealmSwift

class SingleClassService {
    
    private var classDays: Array<Int> = [0, 0, 0, 0, 0, 0, 0]
    private var location = ""
    private var startTime = Date()
    private var endTime = Date()
    private var startDate = Date()
    private var endDate = Date()
    private var type = ClassType.Class
    private var repeats = "Never"
    
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
}
