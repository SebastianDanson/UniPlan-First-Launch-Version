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
    let reminderIcon = UIImage(systemName: "alarm")

    //MARK: - setupUI
    func setupViews() {
        let nextImage = UIImageView(image: nextIcon!)
        let reminderImage = UIImageView(image: reminderIcon!)

        backgroundColor = .backgroundColor
        addSubview(taskView)
        taskView.addSubview(taskLabel)
        taskView.addSubview(durationStartLabel)
        taskView.addSubview(durationEndLabel)
        taskView.addSubview(nextImage)
        taskView.addSubview(reminderLabel)
        taskView.addSubview(reminderImage)
        taskView.backgroundColor = .carrot
        taskView.layer.borderWidth = 0
        taskLabel.lineBreakMode = .byWordWrapping
        taskLabel.numberOfLines = 0
        
        durationStartLabel.anchor(top: taskView.topAnchor,right: nextImage.leftAnchor, paddingTop: 16, paddingRight:  25)
        durationEndLabel.anchor(top: durationStartLabel.bottomAnchor, left: durationStartLabel.leftAnchor)
        
        taskView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10, paddingBottom: 5)
        nextImage.centerY(in: taskView)
        nextImage.anchor(right: taskView.rightAnchor, paddingRight:  20)
        
        reminderImage.anchor(left: taskLabel.leftAnchor,bottom: taskView.bottomAnchor, paddingBottom: 5 )
        reminderImage.tintColor = .white
        reminderImage.setDimensions(width: 15, height: 15)
        reminderLabel.anchor(left: reminderImage.rightAnchor, bottom: taskView.bottomAnchor, paddingLeft: 3, paddingBottom: 5)
    }
    
    //MARK: - Actions
    func update(task: Task) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mma"
        durationStartLabel.text = "\(dateFormatter.string(from: task.startDate))-"
        durationStartLabel.textColor = .backgroundColor

        durationEndLabel.text = dateFormatter.string(from: task.endDate)
        durationEndLabel.textColor = .backgroundColor

        if task.reminder {
            reminderLabel.text = TaskService.shared.setupReminderString(dateOrTime: task.dateOrTime, reminderTime: [task.reminderTime[0], task.reminderTime[1]], reminderDate: task.reminderDate)
        } else {
            reminderLabel.text = "None"
        }
        reminderLabel.textColor = .backgroundColor
        
        taskLabel.text = task.title
        taskLabel.textColor = .backgroundColor
        
        if taskLabel.text == "" {
            taskLabel.text = "Untitled"
        }
        
        if let text = taskLabel.text {
            let nsString = text as NSString
            if nsString.length >= 25 {
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
        
        taskView.backgroundColor = getColor(colorAsInt: task.color)
    }
}
