//
//  TaskCell.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-03.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//
import UIKit
import SwipeCellKit

var taskName: String = ""
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
    let taskLabel = makeTaskLabel(ofSize: 18, weight: .bold)
    let nextIcon = UIImage(named: "nextMenuButton")
    let durationStartLabel = makeTaskLabel(ofSize: 16, weight: .regular)
    let durationEndLabel = makeTaskLabel(ofSize: 16, weight: .regular)
    let reminderLabel = makeTaskLabel(ofSize: 12, weight: .semibold)
    
    private let taskView: UIView = {
        let taskView = UIView()
        taskView.layer.shadowColor = UIColor.black.cgColor
        taskView.layer.shadowOpacity = 0.1
        taskView.layer.shadowRadius = 0.5
        taskView.layer.shadowOffset = CGSize(width: 0, height: 2)
        taskView.layer.borderWidth = 1
        taskView.layer.borderColor = UIColor.lightGray.cgColor
        taskView.backgroundColor = .lightBlue
        taskView.layer.cornerRadius = 10
        
        return taskView
    }()
    
    //MARK: - setupUI
    func setupViews() {
        let nextImage = UIImageView(image: nextIcon!)
        taskLabel.text = taskName
        backgroundColor = .backgroundColor
        addSubview(taskView)
        taskView.addSubview(taskLabel)
        taskView.addSubview(durationStartLabel)
        taskView.addSubview(durationEndLabel)
        taskView.addSubview(nextImage)
        taskView.addSubview(reminderLabel)
        
        taskLabel.lineBreakMode = .byWordWrapping
        taskLabel.numberOfLines = 0
        
        durationStartLabel.anchor(top: taskView.topAnchor,right: nextImage.leftAnchor, paddingTop: 15, paddingRight:  20)
        durationEndLabel.anchor(top: durationStartLabel.bottomAnchor, left: durationStartLabel.leftAnchor)
        
        taskView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10, paddingBottom: 5)
        nextImage.centerY(in: taskView)
        nextImage.anchor(right: taskView.rightAnchor, paddingRight:  20)
        taskLabel.text = taskName
        
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
                taskLabel.text = nsString.substring(with: NSRange(location: 0, length: 25))
                taskLabel.text?.append("\n\(nsString.substring(with: NSRange(location: 25, length: nsString.length - 25 > 25 ? 25 : nsString.length - 25)))")
                if task.reminder {
                    taskLabel.anchor(top: taskView.topAnchor ,left: taskView.leftAnchor, right: durationStartLabel.leftAnchor, paddingTop: 5, paddingLeft: 20)
                    return
                    
                }
            }
        }
        taskLabel.centerY(in: taskView)
        taskLabel.anchor(left: taskView.leftAnchor, right: durationStartLabel.leftAnchor, paddingLeft: 20)
    }
}
