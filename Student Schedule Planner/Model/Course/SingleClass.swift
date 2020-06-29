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
    @objc dynamic var location = ""
    @objc dynamic var startTime = Date()
    @objc dynamic var endTime = Date()
    @objc dynamic var reminder = false
    @objc dynamic var type = "Class"
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var index = 0
    @objc dynamic var course = ""

    var reminderTime = List<Int>() //first index is hours, second index is minutes before task

    required init() {
        classDays.append(objectsIn: [0,0,0,0,0,0,0])
        reminderTime.append(objectsIn: [0, 0])
    }
    
    override class func primaryKey() -> String? {
           return "id"
    }
}
