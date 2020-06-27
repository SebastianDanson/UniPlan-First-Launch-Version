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
    let dateLabel = makeLabel(ofSize: 16, weight: .bold)
    let timeLabel = makeLabel(ofSize: 16, weight: .regular)
    let nextIcon = UIImage(named: "nextMenuButtonGray")
    let reminderLabel = makeLabel(ofSize: 14, weight: .semibold)
    let reminderIcon = UIImage(systemName: "alarm.fill")
    let locationIcon = UIImage(named: "location")
    let locationLabel = makeLabel(ofSize: 14, weight: .semibold)
    var locationImage = UIImageView()
    var reminderImage = UIImageView()
    
    //MARK: - setupUI
    func setupViews() {
        let nextImage = UIImageView(image: nextIcon!)
        reminderImage = UIImageView(image: reminderIcon!)
        locationImage = UIImageView(image: locationIcon!)
        
        backgroundColor = .backgroundColor
        addSubview(taskView)
        
        taskView.addSubview(dateLabel)
        taskView.addSubview(timeLabel)
        taskView.addSubview(nextImage)
        taskView.addSubview(reminderLabel)
        taskView.addSubview(reminderImage)
        taskView.addSubview(locationImage)
        taskView.addSubview(locationLabel)
        
        taskView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 5,
                        paddingLeft: 10, paddingRight: 10, paddingBottom: 5)
        
        dateLabel.anchor(top: taskView.topAnchor, left: taskView.leftAnchor, paddingTop: 10, paddingLeft: 20)
        
        timeLabel.anchor(right: nextImage.rightAnchor, paddingRight: 20)
        timeLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true
        nextImage.centerY(in: taskView)
        nextImage.anchor(right: taskView.rightAnchor, paddingRight:  20)
        
        reminderImage.anchor(left: locationLabel.rightAnchor, bottom: taskView.bottomAnchor, paddingLeft: 10, paddingBottom: 4)
        reminderImage.tintColor = .mainBlue
        reminderImage.setDimensions(width: 15, height: 15)
        reminderLabel.anchor(left: reminderImage.rightAnchor, bottom: taskView.bottomAnchor, paddingLeft: 2, paddingBottom: 5)
        
        locationImage.anchor(left: dateLabel.leftAnchor, bottom: taskView.bottomAnchor, paddingBottom: 5)
        locationImage.setDimensions(width: 15, height: 15)
        locationLabel.anchor(left: locationImage.rightAnchor,
                             bottom: taskView.bottomAnchor,
                             paddingLeft: 2,
                             paddingBottom: 5 )
    }
    
    //MARK: - Actions
    func update(quiz: Quiz? = nil, exam: Exam? = nil) {
        if let quiz = quiz {
            dateLabel.text = formatDate(from: quiz.startDate)
            timeLabel.text = "\(formatTime(from: quiz.startDate))-\(formatTime(from: quiz.endDate))"
            locationLabel.text = quiz.location
            
            if quiz.reminder {
                reminderLabel.text = TaskService.shared.setupReminderString(dateOrTime: quiz.dateOrTime, reminderTime: [quiz.reminderTime[0], quiz.reminderTime[1]], reminderDate: quiz.reminderDate)
            } else {
                reminderLabel.text = "None"
            }
            
            if quiz.location == "" {
                locationLabel.text = "Not Set"
            }
        }
        
        if let exam = exam {
            dateLabel.text = formatDate(from: exam.startDate)
            timeLabel.text = "\(formatTime(from: exam.startDate))-\(formatTime(from: exam.endDate))"
            
            locationLabel.text = exam.location
            
            if exam.reminder {
                reminderLabel.text = TaskService.shared.setupReminderString(dateOrTime: exam.dateOrTime, reminderTime: [exam.reminderTime[0], exam.reminderTime[1]], reminderDate: exam.reminderDate)
            } else {
                reminderLabel.text = "None"
            }
            
            if exam.location == "" {
                locationLabel.text = "Not Set"
            }
        }
    }
}


