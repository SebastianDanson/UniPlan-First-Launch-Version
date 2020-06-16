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
    @objc dynamic var repeats = "Never"
    @objc dynamic var classStartDate = Date()
    @objc dynamic var classEndDate = Date()
    @objc dynamic var type = ""
    @objc dynamic var location = ""
    @objc dynamic var startTime = Date()
    @objc dynamic var endTime = Date()
    @objc dynamic var reminder = false
    var reminderTime = List<Int>() //first index is hours, second index is minutes before task
    
    required init() {
        classDays.append(objectsIn: [0,0,0,0,0,0,0])
        reminderTime.append(objectsIn: [0, 0])
    }
}
