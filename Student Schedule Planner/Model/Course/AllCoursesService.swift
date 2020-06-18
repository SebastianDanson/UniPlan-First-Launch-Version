//
//  AllCoursesService.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-11.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import Foundation
import RealmSwift

class AllCoursesService {
    
    private var courses: Results<Course>?
    private var selectedCourse: Course?
    private var courseIndex = 0

    static let shared = AllCoursesService()
    
    private init(){}
    
    func updateCourses() {
        courses = realm.objects(Course.self)
    }
    
    //MARK: - courses
    func getCourses() -> Results<Course>?{
        updateCourses()
        return courses
    }
    
    func getCourse(atIndex index: Int) -> Course? {
        return courses?[index]
    }
    
    //MARK: - courseIndex
    func getCourseIndex() -> Int {
        return courseIndex
    }
    func setCourseIndex(index: Int) {
        courseIndex = index
    }
    
    //MARK: - Selected Course
    func getSelectedCourse() -> Course? {
        return AllCoursesService.shared.getCourse(atIndex: AllCoursesService.shared.getCourseIndex())
    }
    
    func setSelectedCourse(course: Course?){
        selectedCourse = course
    }
    
}
