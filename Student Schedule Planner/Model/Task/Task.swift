//
//  Task.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-04.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift

class Task: Object {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var startDate: Date = Date()
    @objc dynamic var endDate: Date = Date()
    @objc dynamic var reminder = false
    @objc dynamic var dateOrTime = 0 //0 means time was set, non zero means date was set
    @objc dynamic var reminderDate: Date = Date()
    @objc dynamic var location = ""
    @objc dynamic var isCourse = false
    var reminderTime = List<Int>() //first index is hours, second index is minutes before task
   // var day = LinkingObjects(fromType: Day.self, property: "tasks")

    required init() {
        reminderTime.append(objectsIn: [0, 0])
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
