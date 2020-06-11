//
//  Course.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-11.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import Foundation

import UIKit
import RealmSwift

class Course: Task {
        
    @objc dynamic var course = false
    @objc dynamic var repeats = 0
    @objc dynamic var courseStartDate = Date()
    @objc dynamic var courseEndDate = Date()
    //@objc dynamic var classes = Date()
   // @objc dynamic var courseEndDate = Date()
    
    var courseDays = List<Int>()
   // var courseDay = LinkingObjects(fromType: Day.self, property: "courses")

}
