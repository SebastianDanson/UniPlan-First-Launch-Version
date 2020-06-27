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
    
    //MARK: - setupUI
    func setupViews() {
        let nextImage = UIImageView(image: nextIcon!)
        let reminderImage = UIImageView(image: reminderIcon!)
        
        backgroundColor = .backgroundColor
        addSubview(taskView)
        
        taskView.addSubview(titleLabel)
        taskView.addSubview(dueLabel)
        taskView.addSubview(dateLabel)
        taskView.addSubview(timeLabel)
        taskView.addSubview(nextImage)
        taskView.addSubview(reminderImage)
        taskView.addSubview(reminderLabel)
        
        taskView.anchor(top: topAnchor,
                        left: leftAnchor,
                        right: rightAnchor,
                        bottom: bottomAnchor,
                        paddingTop: 5,
                        paddingLeft: 10,
                        paddingRight: 10,
                        paddingBottom: 5)
        
        titleLabel.anchor(top: taskView.topAnchor, left: taskView.leftAnchor, paddingTop: 20, paddingLeft: 20)
        
        dueLabel.anchor(top: taskView.topAnchor, left: dateLabel.leftAnchor, paddingTop: 5)
        dueLabel.text = "Due:"
        dateLabel.anchor(top: dueLabel.bottomAnchor, right: nextImage.rightAnchor, paddingRight: 20)
        
        timeLabel.anchor(top: dateLabel.bottomAnchor, left: dateLabel.leftAnchor)
        
        nextImage.centerY(in: taskView)
        nextImage.anchor(right: taskView.rightAnchor, paddingRight:  20)
        
        reminderImage.anchor(left: titleLabel.leftAnchor, bottom: taskView.bottomAnchor, paddingBottom: 5)
        reminderLabel.anchor(left: reminderImage.rightAnchor, bottom: taskView.bottomAnchor, paddingLeft: 2, paddingBottom: 5)
        reminderImage.setDimensions(width: 15, height: 15)
        reminderImage.tintColor = .mainBlue
    }
    
    //MARK: - Actions
    func update(assignment: Assignment) {
        titleLabel.text = assignment.title
        dateLabel.text = formatDate(from: assignment.dueDate)
        timeLabel.text = formatTime(from: assignment.dueDate)
        
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


