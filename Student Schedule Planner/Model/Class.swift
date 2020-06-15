//
//  Class.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-14.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift

class Class: Object {
    
    var classDays = List<String>()
    @objc dynamic var repeats = 0
    @objc dynamic var classStartDate = Date()
    @objc dynamic var classEndDate = Date()
    @objc dynamic var type = ""
    @objc dynamic var location = ""
    @objc dynamic var startTime = Date()
    @objc dynamic var endTime = Date()
    
}
