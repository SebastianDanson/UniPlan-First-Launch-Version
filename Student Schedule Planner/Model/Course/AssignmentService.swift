//
//  AssignmentService.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-16.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import Foundation

class AssignmentService {
    
    private var title = ""
    private var dueDate = Date()
    private var assignmentIndex: Int?
    private var numAssignments = 0
    static let shared = AssignmentService()
    
    private init(){}
    
    //MARK: - Title
    func getTitle() -> String {
        return title
    }
    
    func setTitle(title: String) {
        self.title = title
    }
    
    //MARK: - dueDate
    func getDueDate() -> Date {
        return dueDate
    }
    
    func setDueDate(date: Date) {
        dueDate = date
    }
    
    //MARK: - assignmentIndex
    func getAssignmentIndex() -> Int? {
        return assignmentIndex
    }
    func setAssignmentIndex(index: Int?) {
        assignmentIndex = index
    }
    
    //MARK: - numAssignments
    func getNumAssignments() -> Int {
        return numAssignments
    }
    
    func setNumAssignments(num: Int) {
        numAssignments = num
    }
}

