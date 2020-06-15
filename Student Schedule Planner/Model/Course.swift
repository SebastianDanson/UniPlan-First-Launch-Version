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
    var classes = List<Class>()
}
