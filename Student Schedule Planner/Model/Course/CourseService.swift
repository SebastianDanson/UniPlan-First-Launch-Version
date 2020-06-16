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
    private var classes: Results<SingleClass>?
    private var assignments: Results<Assignment>?
    private var quizzes: Results<Quiz>?
    private var exams: Results<Exam>?
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
    
    func getClasses() -> Results<SingleClass>? {
        updateClasses()
        return classes
    }
    
    func updateClasses() {
        classes = realm.objects(SingleClass.self)
    }
    
    //MARK: - Assignments
    func getAssignment(atIndex index: Int) -> Assignment? {
        updateAssignments()
        return assignments?[index]
    }
    
    func getAssignments() -> Results<Assignment>? {
        updateAssignments()
        return assignments
    }
    
    func updateAssignments() {
        assignments = realm.objects(Assignment.self)
    }
    
    //MARK: - Quizzes
    func getQuiz(atIndex index: Int) -> Quiz? {
        updateQuizzes()
        return quizzes?[index]
    }
    
    func getQuizzes() -> Results<Quiz>? {
        updateQuizzes()
        return quizzes
    }
    
    func updateQuizzes() {
        quizzes = realm.objects(Quiz.self)
    }
    
    //MARK: - Exams
    func getExam(atIndex index: Int) -> Exam? {
        updateExams()
        return exams?[index]
    }
    
    func getExams() -> Results<Exam>? {
        updateExams()
        return exams
    }
    
    func updateExams() {
        exams = realm.objects(Exam.self)
    }
    
    //MARK: - quizOrExam
    func getQuizOrExam() -> Int {
        return quizOrExam
    }
    
    func setQuizOrExam(int: Int) {
        quizOrExam = int
    }
}
