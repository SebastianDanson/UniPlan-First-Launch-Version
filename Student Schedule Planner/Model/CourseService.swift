//
//  CourseService.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-11.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import Foundation
import RealmSwift

class CourseService: TaskService {
    
    private var courses: Results<Course>?
    
    static let courseShared = CourseService()
    
    private override init() {
        super.init()
    }
    
    func getCourses() -> Results<Course>?{
        return courses
    }
    
    func getCourse(atIndex index: Int) -> Course? {
        return courses?[index]
    }
}
