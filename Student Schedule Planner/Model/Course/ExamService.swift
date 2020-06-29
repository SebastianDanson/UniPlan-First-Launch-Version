//
//  ExamService.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-17.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

class ExamService {
    
    private var examIndex: Int?
    private var numExams = 0
    static let shared = ExamService()
    
    private init(){}
    
    //MARK: - examIndex
    func getExamIndex() -> Int? {
        return examIndex
    }
    func setExamIndex(index: Int?) {
        examIndex = index
    }
    
    //MARK: - numExams
    func getNumExams() -> Int {
        return numExams
    }
    
    func setNumExams(num: Int) {
        numExams = num
    }
}
