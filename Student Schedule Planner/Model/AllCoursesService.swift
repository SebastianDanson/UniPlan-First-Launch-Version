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
    
    private var courses: Results<Course>? //All of the Users courses
    private var selectedCourse: Course?
    private var courseIndex: Int?
    private var addSummative = false //Changes how the CoursesVC looks if you are adding a summative from the SummativesVC
    private var addNote = false //Changes how the CoursesVC looks if you are adding a not from the notesVC
    
    static let shared = AllCoursesService()
    
    private init(){}
    
    //Updates courses when a user edits or add one
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
        
        if let index = index {
            selectedCourse = courses?[index]
        }
    }
    
    //MARK: - Selected Course
    func getSelectedCourse() -> Course? {
        return selectedCourse
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
    
    //MARK: - addNote
    func getAddNote() -> Bool {
        return addNote
    }
    
    func setAddNote(bool: Bool) {
        addNote = bool
    }
}
