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
    
    private var classes: List<SingleClass>?
    private var assignments: List<Assignment>?
    private var quizzes: List<Quiz>?
    private var exams: List<Exam>?
    
    private var selectedQuiz: Quiz?
    private var selectedExam: Exam?
    private var selectedAssignment: Assignment?
    
    private var quizIndex: Int?
    private var examIndex: Int?
    private var assignmentIndex: Int?
    
    private var startDate = Date()
    private var endDate = Date()
    
    private var quizOrExam = 0 //0 -> quiz, non zero ->Exam
    
    static let shared = CourseService()
    private init() {}
    
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
        let id = AllCoursesService.shared.getSelectedCourse()?.id
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
        let id = AllCoursesService.shared.getSelectedCourse()?.id
        if let course = realm.objects(Course.self).filter("id == %@", id).first {
            assignments = course.assignments
        }
    }
    
    func getSelectedAssignment() -> Assignment? {
        return selectedAssignment
    }
    
    func setSelectedAssignment(assignment: Assignment?) {
        selectedAssignment = assignment
    }
    
    func setAssignmentIndex(index: Int?) {
        assignmentIndex = index
        if let index = index {
            selectedAssignment = assignments?[index]
        }
    }
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
        let id = AllCoursesService.shared.getSelectedCourse()?.id
        if let course = realm.objects(Course.self).filter("id == %@", id).first {
            quizzes = course.quizzes
        }
    }
    
    func setQuizIndex(index: Int?) {
        quizIndex = index
        if let index = index {
            selectedQuiz = quizzes?[index]
        }
    }
    
    func getSelectedQuiz() -> Quiz? {
        return selectedQuiz
    }
    
    func setSelectedQuiz(quiz: Quiz?) {
        selectedQuiz = quiz
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
        let id = AllCoursesService.shared.getSelectedCourse()?.id
        if let course = realm.objects(Course.self).filter("id == %@", id).first {
            exams = course.exams
        }
    }
    
    func setExamIndex(index: Int?) {
        examIndex = index
        if let index = index {
            selectedExam = exams?[index]
        }
    }
    
    func getSelectedExam() -> Exam? {
        return selectedExam
    }
    
    func setSelectedExam(exam: Exam?) {
        selectedExam = exam
    }
    
    //MARK: - quizOrExam
    func getQuizOrExam() -> Int {
        return quizOrExam
    }
    
    func setQuizOrExam(int: Int) {
        quizOrExam = int
    }
    
    //MARK: - Start Date
    func getStartDate() -> Date{
        return startDate
    }
    
    func setStartDate(date: Date) {
        startDate = date
    }
    
    //MARK: - End Date
    func getEndDate() -> Date{
        return endDate
    }
    
    func setEndDate(date: Date) {
        endDate = date
    }
}
