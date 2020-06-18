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

class Course: Object {
    
    @objc dynamic var color = 0
    @objc dynamic var startDate = Date()
    @objc dynamic var endDate = Date()
    var title = ""
    var classes = List<SingleClass>()
    var assignments = List<Assignment>()
    var quizzes = List<Quiz>()
  
    var exams = List<Exam>()
    
    @objc dynamic var id = UUID().uuidString
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
