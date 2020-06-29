//
//  Assignment.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-22.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift

class Assignment: Object {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var reminder = false
    @objc dynamic var dateOrTime = 0 //0 means time was set, non zero means date was set
    @objc dynamic var reminderDate: Date = Date()
    @objc dynamic var dueDate = Date()
    @objc dynamic var index = 0
    @objc dynamic var course = ""

    var reminderTime = List<Int>() //first index is hours, second index is minutes before task

    required init() {
        reminderTime.append(objectsIn: [0, 0])
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
