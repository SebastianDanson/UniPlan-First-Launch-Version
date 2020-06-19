//
//  TaskCell.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-03.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//
import UIKit
import SwipeCellKit

class TaskCell: SwipeTableViewCell {
    
    //MARK: - lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    let taskLabel = makeLabel(ofSize: 18, weight: .bold)
    let nextIcon = UIImage(named: "nextMenuButton")
    let durationStartLabel = makeLabel(ofSize: 16, weight: .semibold)
    let durationEndLabel = makeLabel(ofSize: 16, weight: .semibold)
    let reminderLabel = makeLabel(ofSize: 12, weight: .semibold)
    let taskView = makeTaskView()
    
    //MARK: - setupUI
    func setupViews() {
        let nextImage = UIImageView(image: nextIcon!)
        backgroundColor = .backgroundColor
        addSubview(taskView)
        taskView.addSubview(taskLabel)
        taskView.addSubview(durationStartLabel)
        taskView.addSubview(durationEndLabel)
        taskView.addSubview(nextImage)
        taskView.addSubview(reminderLabel)
        taskView.backgroundColor = .carrot
        taskView.layer.borderWidth = 0
        taskLabel.lineBreakMode = .byWordWrapping
        taskLabel.numberOfLines = 0
        
        durationStartLabel.anchor(top: taskView.topAnchor,right: nextImage.leftAnchor, paddingTop: 16, paddingRight:  25)
        durationEndLabel.anchor(top: durationStartLabel.bottomAnchor, left: durationStartLabel.leftAnchor)
        
        taskView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10, paddingBottom: 5)
        nextImage.centerY(in: taskView)
        nextImage.anchor(right: taskView.rightAnchor, paddingRight:  20)
        
        reminderLabel.anchor(left: taskLabel.leftAnchor, bottom: taskView.bottomAnchor, paddingBottom: 5)
    }
    
    //MARK: - Actions
    func update(task: Task) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mma"
        durationStartLabel.text = "\(dateFormatter.string(from: task.startDate))-"
        durationEndLabel.text = dateFormatter.string(from: task.endDate)
        reminderLabel.text = TaskService.shared.setupReminderString(task: task)
        
        taskLabel.text = task.title 
        if taskLabel.text == "" {
            taskLabel.text = "Untitled"
        }
        
        if let text = taskLabel.text {
            let nsString = text as NSString
            if nsString.length >= 25
            {
                taskLabel.text = nsString.substring(with: NSRange(location: 0, length: 20))
                taskLabel.text?.append("\n\(nsString.substring(with: NSRange(location: 20, length: nsString.length - 20 > 20 ? 20 : nsString.length - 20)))")

                if task.reminder {
                    taskLabel.anchor(top: taskView.topAnchor ,left: taskView.leftAnchor, right: durationStartLabel.leftAnchor, paddingTop: 5, paddingLeft: 30)
                    return
                }
            }
        }
        taskLabel.centerY(in: taskView)
        taskLabel.anchor(left: taskView.leftAnchor, right: durationStartLabel.leftAnchor, paddingLeft: 30)
    }
}
