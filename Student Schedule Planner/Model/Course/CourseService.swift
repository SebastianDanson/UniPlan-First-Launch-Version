//
//  CourseService.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-15.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import Foundation
import RealmSwift

class CourseService {
    
    let realm = try! Realm()
    
    private var isCourse = false
    private var classes: List<SingleClass>?
    private var assignments: List<Assignment>?
    private var quizzes: List<Quiz>?
    private var exams: List<Exam>?
    private var quizOrExam = 0 //0 -> quiz, non zero ->Exam
    
    
    static let shared = CourseService()
    private init() {}
    
    //MARK: - IsCourse
    func getIsCourse() -> Bool {
        return isCourse
    }
    
    func setIsCourse(bool: Bool) {
        isCourse = bool
    }
    
    //MARK: - Classes
    func getClass(atIndex index: Int) -> SingleClass? {
        updateClasses()
        return classes?[index]
    }
    
    func getClasses() -> List<SingleClass>? {
        updateClasses()
        return classes
    }
    
    func updateClasses() {
        let id = AllCoursesService.courseShared.getSelectedCourse()?.id
        if let course = realm.objects(Course.self).filter("id == %@", id).first {
            classes = course.classes
        }
    }
    
    //MARK: - Assignments
    func getAssignment(atIndex index: Int) -> Assignment? {
        updateAssignments()
        return assignments?[index]
    }
    
    func getAssignments() -> List<Assignment>? {
        updateAssignments()
        return assignments
    }
    
    func updateAssignments() {
        let id = AllCoursesService.courseShared.getSelectedCourse()?.id
        if let course = realm.objects(Course.self).filter("id == %@", id).first {
            assignments = course.assignments
        }    }
    
    //MARK: - Quizzes
    func getQuiz(atIndex index: Int) -> Quiz? {
        updateQuizzes()
        return quizzes?[index]
    }
    
    func getQuizzes() -> List<Quiz>? {
        updateQuizzes()
        return quizzes
    }
    
    func updateQuizzes() {
        let id = AllCoursesService.courseShared.getSelectedCourse()?.id
        if let course = realm.objects(Course.self).filter("id == %@", id).first {
            quizzes = course.quizzes
        }
    }
    
    //MARK: - Exams
    func getExam(atIndex index: Int) -> Exam? {
        updateExams()
        return exams?[index]
    }
    
    func getExams() -> List<Exam>? {
        updateExams()
        return exams
    }
    
    func updateExams() {
        let id = AllCoursesService.courseShared.getSelectedCourse()?.id
        if let course = realm.objects(Course.self).filter("id == %@", id).first {
            exams = course.exams
        }
    }
    
    //MARK: - quizOrExam
    func getQuizOrExam() -> Int {
        return quizOrExam
    }
    
    func setQuizOrExam(int: Int) {
        quizOrExam = int
    }
}
