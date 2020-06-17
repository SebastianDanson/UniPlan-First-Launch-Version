//
//  Exam.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-14.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift

class Exam: Object {
    
    @objc dynamic var startDate = Date()
    @objc dynamic var endTime = Date()
    @objc dynamic var id = UUID().uuidString
       
       override class func primaryKey() -> String? {
              return "id"
       }
}
