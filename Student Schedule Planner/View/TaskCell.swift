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
    let taskLabel = makeLabel(ofSize: 20, weight: .bold)
    let nextIcon = UIImage(named: "nextMenuButton")
    let startTimeLabel = makeLabel(ofSize: 16, weight: .bold)
    let endTimeLabel = makeLabel(ofSize: 16, weight: .bold)
    let dateLabel = makeLabel(ofSize: 14, weight: .bold)
    let reminderLabel = makeLabel(ofSize: 12, weight: .semibold)
    let taskView = makeTaskView()
    let reminderIcon = UIImage(systemName: "alarm.fill")
    let locationIcon = UIImage(named: "locationWhiteFill")
    let locationLabel = makeLabel(ofSize: 12, weight: .bold)
    let dueLabel = makeLabel(ofSize: 14, weight: .bold)
    var locationImage = UIImageView()
    var reminderImage = UIImageView()
    var nextImage = UIImageView()

    var reminderLeftAnchorConstaint = NSLayoutConstraint()
    var reminderOtherAnchorConstaint = NSLayoutConstraint()
    
    var startTimeTopAnchorConstaint = NSLayoutConstraint()
    var startTimeOtherAnchorConstaint = NSLayoutConstraint()
    var startTimeSummativeAnchorConstraint = NSLayoutConstraint()
    
    //MARK: - setupUI
    func setupViews() {
       nextImage = UIImageView(image: nextIcon!)
        reminderImage = UIImageView(image: reminderIcon!)
       locationImage = UIImageView(image: locationIcon!)
        
        backgroundColor = .backgroundColor
        addSubview(taskView)
        taskView.addSubview(taskLabel)
        taskView.addSubview(startTimeLabel)
        taskView.addSubview(endTimeLabel)
        taskView.addSubview(nextImage)
        taskView.addSubview(reminderLabel)
        taskView.addSubview(reminderImage)
        taskView.addSubview(locationImage)
        taskView.addSubview(locationLabel)
        
        taskView.layer.borderWidth = 0
        taskView.backgroundColor = .backgroundColor
        taskLabel.lineBreakMode = .byWordWrapping
        taskLabel.numberOfLines = 0

        taskView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor,
                        paddingTop: 5, paddingLeft: 10, paddingRight: 10, paddingBottom: 5)
        
        nextImage.centerY(in: taskView)
        nextImage.anchor(right: taskView.rightAnchor, paddingRight:  20)
        
        reminderImage.anchor(bottom: taskView.bottomAnchor, paddingBottom: 4)
        reminderImage.tintColor = .white
        reminderImage.setDimensions(width: 15, height: 15)
        reminderLabel.anchor(left: reminderImage.rightAnchor, bottom: taskView.bottomAnchor, paddingLeft: 2, paddingBottom: 5)
        
        locationImage.anchor(left: taskLabel.leftAnchor, bottom: taskView.bottomAnchor, paddingBottom: 5 )
        locationImage.setDimensions(width: 15, height: 15)
        locationLabel.anchor(left: locationImage.rightAnchor,
                             bottom: taskView.bottomAnchor,
                             paddingLeft: 2,
                             paddingBottom: 5 )
        
        reminderLeftAnchorConstaint = reminderImage.leftAnchor.constraint(equalTo: locationLabel.rightAnchor, constant: 10)
        reminderOtherAnchorConstaint = reminderImage.leftAnchor.constraint(equalTo: taskLabel.leftAnchor)
        reminderLeftAnchorConstaint.isActive = true
        
        startTimeLabel.anchor(right: nextImage.leftAnchor, paddingRight:  25)
        endTimeLabel.anchor(top: startTimeLabel.bottomAnchor, left: startTimeLabel.leftAnchor)
        startTimeTopAnchorConstaint = startTimeLabel.centerYAnchor.constraint(equalTo: taskView.centerYAnchor)
        startTimeOtherAnchorConstaint = startTimeLabel.topAnchor.constraint(equalTo: taskView.topAnchor, constant: 16)
        startTimeSummativeAnchorConstraint = startTimeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 2)    
    }
    
    //MARK: - Actions
    func update(task: Task, summative: Bool) {
        reminderImage.isHidden = false
        reminderLabel.isHidden = false
        locationImage.isHidden = false
        locationLabel.isHidden = false
        dateLabel.isHidden = true

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mma"
        startTimeLabel.text = "\(dateFormatter.string(from: task.startDate))-"
        startTimeLabel.textColor = .white
        
        endTimeLabel.text = dateFormatter.string(from: task.endDate)
        endTimeLabel.textColor = .white
        
        if task.reminder {
            reminderLabel.text = TaskService.shared.setupReminderString(dateOrTime: task.dateOrTime, reminderTime: [task.reminderTime[0], task.reminderTime[1]], reminderDate: task.reminderDate)
        } else {
            reminderLabel.isHidden = true
            reminderImage.isHidden = true
        }
        reminderLabel.textColor = .white
        locationLabel.textColor = .white
        locationLabel.text = task.location
        
        taskLabel.text = task.title
        taskLabel.textColor = .backgroundColor
        
        if taskLabel.text == "" {
            taskLabel.text = "Untitled"
        }
        
        if let text = taskLabel.text {
            let nsString = text as NSString
            if nsString.length >= 21 {
                taskLabel.text = nsString.substring(with: NSRange(location: 0, length: 21))
                taskLabel.text?.append("\n\(nsString.substring(with: NSRange(location: 21, length: nsString.length - 21 > 21 ? 21 : nsString.length - 21)))")
                
                taskLabel.anchor(top: taskView.topAnchor, left: taskView.leftAnchor, right: startTimeLabel.leftAnchor, paddingTop: 5, paddingLeft: 20)
            } else {
                taskLabel.anchor(left: taskView.leftAnchor, paddingLeft: 20)
                taskLabel.centerY(in: taskView)
            }
        }

        if task.type == "assignment" {
            endTimeLabel.isHidden = true
            startTimeTopAnchorConstaint.isActive = true
            startTimeLabel.text = dateFormatter.string(from: task.startDate)
            taskView.addSubview(dueLabel)
            dueLabel.text = "Due:"
            dueLabel.textColor = .white
            let paddingTop: CGFloat = summative ? 5:10
            dueLabel.anchor(top: taskView.topAnchor, left: startTimeLabel.leftAnchor, paddingTop: paddingTop)
        } else {
            startTimeOtherAnchorConstaint.isActive = true
        }
        
        if task.location == "" {
            locationImage.isHidden = true
            locationLabel.isHidden = true
            reminderOtherAnchorConstaint.isActive = true
            reminderLeftAnchorConstaint.isActive = false
        }
        taskView.backgroundColor = getColor(colorAsInt: task.color)
        
        //Changes the layout for the summativeVC cells
        if summative {
            dateLabel.isHidden = false
            taskView.addSubview(dateLabel)
            dateLabel.text = formatDateNoYear(from: task.startDate)
            dateLabel.textColor = .white
            startTimeLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            endTimeLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            startTimeOtherAnchorConstaint.isActive = false
            startTimeTopAnchorConstaint.isActive = false
            startTimeSummativeAnchorConstraint.isActive = true
            
            if task.type == "assignment" {
                dateLabel.anchor(top: dueLabel.bottomAnchor, left: startTimeLabel.leftAnchor)
            } else {
                dateLabel.anchor(top: taskView.topAnchor, left: startTimeLabel.leftAnchor, paddingTop: 7)
            }
        }
    }
}
