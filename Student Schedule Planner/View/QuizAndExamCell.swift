//
//  QuizCell.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-14.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import SwipeCellKit

class QuizAndExamCell: SwipeTableViewCell {
    
    //MARK: - lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    
    let taskView = makeTaskView()
    let dateLabel = makeLabel(ofSize: 16, weight: .regular)
    let timeLabel = makeLabel(ofSize: 16, weight: .regular)
    let nextIcon = UIImage(named: "nextMenuButton")
    
    //MARK: - setupUI
    func setupViews() {
        let nextImage = UIImageView(image: nextIcon!)

        backgroundColor = .backgroundColor
        addSubview(taskView)
        
        taskView.addSubview(dateLabel)
        taskView.addSubview(timeLabel)
        taskView.addSubview(nextImage)
        
        taskView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 10,
                        paddingLeft: 10, paddingRight: 10, paddingBottom: 10)
        
        dateLabel.centerY(in: taskView)
        dateLabel.anchor(left: taskView.leftAnchor, paddingLeft: 20)
        dateLabel.text = "March 6th"

        timeLabel.centerY(in: taskView)
        timeLabel.anchor(right: nextImage.rightAnchor, paddingRight: 30)
        timeLabel.text = "12:00PM-01:00PM"
        
        nextImage.centerY(in: taskView)
        nextImage.anchor(right: taskView.rightAnchor, paddingRight:  20)
    }
    
    //MARK: - Actions
    func update(quiz: Quiz? = nil, exam: Exam? = nil) {
        if let quiz = quiz {
        dateLabel.text = formatDate(from: quiz.startDate)
        timeLabel.text = "\(formatTime(from: quiz.startDate))-\(formatTime(from: quiz.endTime))"
        }
        
        if let exam = exam {
            dateLabel.text = formatDate(from: exam.startDate)
            timeLabel.text = "\(formatTime(from: exam.startDate))-\(formatTime(from: exam.endTime))"
        }
        
    }
}


