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
    
    @objc dynamic var startDate = Date()
    @objc dynamic var endDate = Date()
    @objc dynamic var title = ""
    var color = List<Double>() //Stores RGB values of color
    
    var classes = List<SingleClass>()
    var assignments = List<Assignment>()
    var quizzes = List<Quiz>()
    var exams = List<Exam>()
    var notes = List<Note>()
    
    @objc dynamic var id = UUID().uuidString
    
    required init() {
         color.append(objectsIn: [0, 0, 0])
     }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
