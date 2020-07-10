//
//  AssignmentCell.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-14.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import SwipeCellKit

class AssignmentCell: SwipeTableViewCell {
    
    //MARK: - lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    let reminderIcon = UIImage(systemName: "alarm.fill")
    let reminderLabel = makeLabel(ofSize: 14, weight: .semibold)
    let taskView = makeTaskView()
    let titleLabel = makeLabel(ofSize: 18, weight: .semibold)
    let dueLabel = makeLabel(ofSize: 14, weight: .semibold)
    let dateLabel = makeLabel(ofSize: 16, weight: .regular)
    let timeLabel = makeLabel(ofSize: 16, weight: .regular)
    let nextIcon = UIImage(named: "nextMenuButtonGray")
    var reminderImage = UIImageView()
    
    //MARK: - setupUI
    func setupViews() {
        let color = TaskService.shared.getColor()
        
        let nextImage = UIImageView(image: nextIcon!)
        reminderImage = UIImageView(image: reminderIcon!)
        
        let marginGuide = contentView.layoutMarginsGuide
        
        backgroundColor = .backgroundColor
        
        contentView.addSubview(taskView)
        taskView.addSubview(titleLabel)
        taskView.addSubview(dueLabel)
        taskView.addSubview(dateLabel)
        taskView.addSubview(timeLabel)
        taskView.addSubview(nextImage)
        taskView.addSubview(reminderImage)
        taskView.addSubview(reminderLabel)
        
        taskView.anchor(top: topAnchor,
                        bottom: bottomAnchor,
                        paddingTop: 5,
                        paddingBottom: 5)
        
        taskView.setDimensions(width: UIScreen.main.bounds.width - 20)
        taskView.centerX(in: self)
        taskView.layer.borderColor = color.cgColor
        
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.setDimensions(width: UIScreen.main.bounds.width * 0.57)
        titleLabel.anchor(top: marginGuide.topAnchor,
                          left: marginGuide.leftAnchor,
                          bottom: marginGuide.bottomAnchor,
                          paddingTop: 20,
                          paddingLeft: 10,
                          paddingBottom: 20)
        
        dueLabel.anchor(left: dateLabel.leftAnchor, bottom: dateLabel.topAnchor)
        dueLabel.text = "Due:"
        
        dateLabel.centerY(in: taskView)
        dateLabel.anchor(right: nextImage.rightAnchor, paddingRight: 20)
        
        timeLabel.anchor(top: dateLabel.bottomAnchor, left: dateLabel.leftAnchor)
        
        nextImage.centerY(in: taskView)
        nextImage.anchor(right: taskView.rightAnchor, paddingRight:  20)
        
        reminderImage.anchor(left: titleLabel.leftAnchor,
                             bottom: taskView.bottomAnchor,
                             paddingBottom: 5)
        
        reminderLabel.anchor(left: reminderImage.rightAnchor,
                             bottom: taskView.bottomAnchor,
                             paddingLeft: 2,
                             paddingBottom: 5)
        reminderImage.setDimensions(width: 15, height: 15)
    }
    
    func update(assignment: Assignment) {
        titleLabel.text = assignment.title
        dateLabel.text = formatDateNoDay(from: assignment.dueDate)
        timeLabel.text = formatTime(from: assignment.dueDate)
        
        let course = AllCoursesService.shared.getSelectedCourse()
        let color = UIColor.init(red: CGFloat(course?.color[0] ?? 0), green: CGFloat(course?.color[1] ?? 0), blue: CGFloat(course?.color[2] ?? 0), alpha: 1)
        
        reminderImage.tintColor = color
        taskView.layer.borderColor = color.cgColor
        
        if assignment.title == "" {
            titleLabel.text = "Untitled"
        }
        if assignment.reminder {
            reminderLabel.text = TaskService.shared.setupReminderString(dateOrTime: assignment.dateOrTime, reminderTime: [assignment.reminderTime[0], assignment.reminderTime[1]], reminderDate: assignment.reminderDate)
        } else {
            reminderLabel.text = "None"
        }
    }
}


