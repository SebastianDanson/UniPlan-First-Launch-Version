//
//  SingleClass.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-14.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift

class SingleClass: Object {
    
    var classDays = List<Int>()
    
    @objc dynamic var startDate = Date() //Date of first class
    @objc dynamic var endDate = Date() //Date of last cass
    @objc dynamic var startTime = Date() //Start time of each class
    @objc dynamic var endTime = Date() //End time of each class
    
    var repeats = List<Int>() //How frequent the class repeats
    @objc dynamic var location = ""
    
    @objc dynamic var reminder = false
    @objc dynamic var type = "Class"
    @objc dynamic var subType = "Class" //Type of class - Lab, tutorial, lecture, etc
    @objc dynamic var id = UUID().uuidString //Unique id
    @objc dynamic var courseId = "" //Id of the course that the class belongs to
    
    var reminderTime = List<Int>() //first index is hours, second index is minutes before task
    
    required init() {
        classDays.append(objectsIn: [0,0,0,0,0,0,0])
        reminderTime.append(objectsIn: [0, 0])
        repeats.append(objectsIn: [1, 0])
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
