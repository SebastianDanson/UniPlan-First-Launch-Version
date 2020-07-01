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
    private var courseIndex: Int?
    private var addSummative = false

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
    func getCourseIndex() -> Int? {
        return courseIndex
    }
    func setCourseIndex(index: Int?) {
        courseIndex = index
    }
    
    //MARK: - Selected Course
    func getSelectedCourse() -> Course? {
        if let index = courseIndex {
            return getCourse(atIndex: index)
        }
        return nil
    }
    
    func setSelectedCourse(course: Course?){
        selectedCourse = course
    }
    
    //MARK: - addSummative
    func getAddSummative() -> Bool {
        return addSummative
    }
    func setAddSummative(bool: Bool) {
        addSummative = bool
    }
}
