//
//  Routine.swift
//  UniPlan
//
//  Created by Student on 2020-07-12.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift

class Routine: Object {
    
    var days = List<Int>()
    
    @objc dynamic var startTime = Date()
    @objc dynamic var endTime = Date()
    @objc dynamic var startDate = Date()
    @objc dynamic var endDate = Date() 
    var repeats = List<Int>() //How often the routine repeats
    @objc dynamic var location = ""
    @objc dynamic var reminder = false
    @objc dynamic var id = UUID().uuidString //Unique id
    @objc dynamic var title = ""

    var color = List<Double>() //Stores RGB values of color
    
    var reminderTime = List<Int>() //first index is hours, second index is minutes before task
    
    required init() {
        days.append(objectsIn: [0,0,0,0,0,0,0])
        color.append(objectsIn: [0, 0, 0])
        reminderTime.append(objectsIn: [0, 0])
        repeats.append(objectsIn: [1, 0])
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
