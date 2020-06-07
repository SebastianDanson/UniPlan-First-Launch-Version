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
    @objc dynamic var title: String = ""
    @objc dynamic var startDate: Date = Date()
    @objc dynamic var endDate: Date = Date()
    var day = LinkingObjects(fromType: Day.self, property: "tasks")
}
