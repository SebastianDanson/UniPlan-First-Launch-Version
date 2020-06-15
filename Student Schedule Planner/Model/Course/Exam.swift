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
    @objc dynamic var quizStartDate = Date()
    @objc dynamic var quizEndDate = Date()
}
