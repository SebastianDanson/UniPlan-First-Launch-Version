//
//  Task.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-04.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import Foundation

class Task {
    
    var title: String
    var startDate: Date
    var endDate: Date
    
    init(title: String, startDate: Date, endDate: Date) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
    }
}
