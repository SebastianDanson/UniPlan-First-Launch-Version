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
    let taskLabel = makeTaskLabel()
    let nextIcon = UIImage(named: "nextMenuButton")
    
    
    private let durationLabel: UILabel = {
        let durationLabel = UILabel()
        durationLabel.font = UIFont.systemFont(ofSize: 18)
        durationLabel.textColor = .darkBlue
        
        return durationLabel
    }()
    
    private let reminderLabel: UILabel = {
        let reminderLabel = UILabel()
        reminderLabel.font = UIFont.systemFont(ofSize: 12)
        reminderLabel.textColor = .darkBlue
        reminderLabel.text = ""
        return reminderLabel
    }()
    
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
        taskView.addSubview(durationLabel)
        taskView.addSubview(nextImage)
        taskView.addSubview(reminderLabel)
        
        taskLabel.centerY(in: taskView)
        taskLabel.anchor(left: taskView.leftAnchor, paddingLeft: 30)
        
        durationLabel.centerYAnchor.constraint(equalTo: taskLabel.centerYAnchor).isActive = true
        durationLabel.anchor(right: nextImage.leftAnchor, paddingRight:  20)
        
        taskView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10, paddingBottom: 5)
        nextImage.centerYAnchor.constraint(equalTo: taskLabel.centerYAnchor).isActive = true
        nextImage.anchor(right: taskView.rightAnchor, paddingRight:  20)
        taskLabel.text = taskName
        
        reminderLabel.anchor(left: taskLabel.leftAnchor, bottom: taskView.bottomAnchor, paddingBottom: 10)
    }
    
    //MARK: - Actions
    func update(task: Task) {
        taskLabel.text = task.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mma"
        durationLabel.text = "\(dateFormatter.string(from: task.startDate))-\(dateFormatter.string(from: task.endDate))"
        
        if task.reminder {
            if task.dateOrTime == 0 {
                let reminderTime: [Int] = [task.reminderTime[0], task.reminderTime[1]]
                let hourString = reminderTime[0] == 1 ? "Hour" : "Hours"

                reminderLabel.text = "Reminder: \(reminderTime[0]) \(hourString), \(reminderTime[1]) min before"
            } else {
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "E MMM d, h:mm a"
                let date = dateFormat.string(from: task.reminderDate)
                reminderLabel.text = "Reminder: \(date)"
            }
        } else {
            reminderLabel.text = ""
        }
        
    }
    
}
