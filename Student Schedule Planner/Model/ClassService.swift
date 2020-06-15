//
//  ClassService.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-14.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import Foundation
import RealmSwift

class ClassService {
    
    private var classDays = Set<String>()
    private var location = ""
    private var startTime = Date()
    private var endTime = Date()
    private var startDate = Date()
    private var endDate = Date()
    private var type = ClassType(rawValue: 0)
    private var repeats = "Never"
    
    static let shared = ClassService()
    
    private init(){}
    
    //MARK: - Class Days
    func getClassDays() -> Set<String> {
        return classDays
    }
    
    func setClassDays(days: Set<String>) {
        classDays = days
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
    func getStartTime() -> Date {
        return startTime
    }
    
    func setStartTime(time: Date) {
        startTime = time
    }
    
    //MARK: - End Time
    func getEndTime() -> Date {
        return endTime
    }
    
    func setEndTime(time: Date) {
        endTime = time
    }
    
    //MARK: - Start Date
    func getStartDate() -> Date {
        return startDate
    }
    
    func setStartDate(date: Date) {
        startDate = date
    }
    
    //MARK: - End Date
    func getEndDate() -> Date {
        return endDate
    }
    
    func setEndDate(date: Date) {
        endDate = date
    }
    
    //MARK: - Type
    func getType() -> ClassType? {
        return type
    }
    
    func setType(classType: ClassType) {
        type = classType
    }
    
}
