//
//  QuizService.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-17.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

class QuizService {
    
    private var quizIndex: Int?
    private var numQuizzes = 0

    static let shared = QuizService()
    
    private init(){}
    
    //MARK: - quizIndex
    func getQuizIndex() -> Int? {
        return quizIndex
    }
    func setQuizIndex(index: Int?) {
        quizIndex = index
    }
    
    //MARK: - numQuizzes
    func getNumQuizzes() -> Int {
        return numQuizzes
    }
    
    func setNumQuizzes(num: Int) {
        numQuizzes = num
    }
}

