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
    let startTimeLabel = makeLabel(ofSize: 16, weight: .bold)
    let endTimeLabel = makeLabel(ofSize: 16, weight: .bold)
    let dateLabel = makeLabel(ofSize: 14, weight: .bold) //For the cells in the summative VC
    let reminderLabel = makeLabel(ofSize: 12, weight: .semibold)
    let dueLabel = makeLabel(ofSize: 14, weight: .bold) //If the task is associated with an assignment
    
    let taskView = makeTaskView()
    let checkImage = UIImage(named: "check")
    var checkImageView = UIImageView()
    
    let reminderIcon = UIImage(systemName: "alarm.fill")
    var reminderImage = UIImageView()
    
    let locationIcon = UIImage(named: "locationWhiteFill")
    let locationLabel = makeLabel(ofSize: 12, weight: .bold)
    var locationImage = UIImageView()
    
    let nextIcon = UIImage(named: "nextMenuButton")
    var nextImage = UIImageView()
    
    let overlay = UIView()
    
    //Anchors for reminderImage
    var reminderLeftAnchorConstaint = NSLayoutConstraint()
    var reminderOtherAnchorConstaint = NSLayoutConstraint()
    
    //Anchors for the startTime label
    var startTimeTopAnchorConstaint = NSLayoutConstraint()
    var startTimeSummativeAnchorConstraint = NSLayoutConstraint()
    var startTimeAssignmentAnchorConstraint = NSLayoutConstraint()
    
    //Anchors for the dueLabel
    var dueLabelTopAnchorConstaint = NSLayoutConstraint()
    var dueLabelOtherAnchorConstaint = NSLayoutConstraint()
    
    //Anchors for the dateLabel
    var dateLabelTopAnchorConstaint = NSLayoutConstraint()
    var dateLabelOtherAnchorConstaint = NSLayoutConstraint()
    
    //MARK: - setupUI
    func setupViews() {
        
        nextImage = UIImageView(image: nextIcon!)
        reminderImage = UIImageView(image: reminderIcon!)
        locationImage = UIImageView(image: locationIcon!)
        checkImageView = UIImageView(image: checkImage!)
        
        backgroundColor = .backgroundColor
        
        contentView.addSubview(taskView)
        taskView.addSubview(taskLabel)
        taskView.addSubview(startTimeLabel)
        taskView.addSubview(endTimeLabel)
        taskView.addSubview(nextImage)
        taskView.addSubview(reminderLabel)
        taskView.addSubview(reminderImage)
        taskView.addSubview(locationImage)
        taskView.addSubview(locationLabel)
        taskView.addSubview(dueLabel)
        taskView.addSubview(dateLabel)
        taskView.addSubview(overlay)
        taskView.addSubview(checkImageView)
        
        taskView.layer.borderWidth = 0
        taskView.backgroundColor = .backgroundColor
        
        taskView.setDimensions(width: UIScreen.main.bounds.width - 20)
        taskView.centerX(in: self)
        taskView.anchor(top: topAnchor,
                        bottom: bottomAnchor,
                        paddingTop: 5,
                        paddingBottom: 5)
        
        taskLabel.lineBreakMode = .byWordWrapping
        taskLabel.numberOfLines = 0
        
        nextImage.centerY(in: taskView)
        nextImage.anchor(right: taskView.rightAnchor, paddingRight:  10)
        
        reminderImage.anchor(bottom: taskView.bottomAnchor, paddingBottom: 3)
        reminderImage.tintColor = .white
        reminderImage.setDimensions(width: 15, height: 15)
        reminderLabel.anchor(left: reminderImage.rightAnchor,
                             bottom: taskView.bottomAnchor,
                             paddingLeft: 2,
                             paddingBottom: 3)
        
        locationImage.anchor(left: taskLabel.leftAnchor, bottom: taskView.bottomAnchor, paddingBottom: 3)
        locationImage.setDimensions(width: 15, height: 15)
        
        locationLabel.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 0.45).isActive = true
        locationLabel.anchor(left: locationImage.rightAnchor,
                             bottom: taskView.bottomAnchor,
                             paddingLeft: 2,
                             paddingBottom: 3)
        
        overlay.setDimensions(width: UIScreen.main.bounds.width - 20)
        overlay.anchor(top: topAnchor,
                       bottom: bottomAnchor,
                       paddingTop: 5,
                       paddingBottom: 5)
        overlay.backgroundColor = UIColor(red: 11/255, green: 232/255, blue: 129/255, alpha: 0.5)
        overlay.layer.cornerRadius = 10
        overlay.centerX(in: taskView)
        
        checkImageView.setDimensions(width: 50, height: 50)
        checkImageView.tintColor = .white
        checkImageView.centerY(in: taskView)
        checkImageView.anchor(right: taskView.rightAnchor, paddingRight: 20)
        
        reminderLeftAnchorConstaint = reminderImage.leftAnchor.constraint(equalTo: locationLabel.rightAnchor, constant: 10)
        reminderOtherAnchorConstaint = reminderImage.leftAnchor.constraint(equalTo: locationImage.leftAnchor)
        reminderLeftAnchorConstaint.isActive = true
        
        startTimeLabel.anchor(left: endTimeLabel.leftAnchor)
        endTimeLabel.anchor(top: startTimeLabel.bottomAnchor,  right: nextImage.leftAnchor, paddingRight:  20)
        
        startTimeTopAnchorConstaint = startTimeLabel.centerYAnchor.constraint(equalTo: taskView.centerYAnchor, constant: -10)
        startTimeSummativeAnchorConstraint = startTimeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor)
        startTimeAssignmentAnchorConstraint = startTimeLabel.centerYAnchor.constraint(equalTo: taskView.centerYAnchor)
        startTimeTopAnchorConstaint.isActive = true
        
        dueLabelTopAnchorConstaint = dueLabel.bottomAnchor.constraint(equalTo: startTimeLabel.topAnchor)
        dueLabelOtherAnchorConstaint = dueLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor)
        
        dateLabelTopAnchorConstaint = dateLabel.centerYAnchor.constraint(equalTo: taskView.centerYAnchor)
        dateLabelOtherAnchorConstaint = dateLabel.bottomAnchor.constraint(equalTo: startTimeLabel.topAnchor, constant: 5)
    }
    
    //MARK: - Actions
    func update(task: Task, summative: Bool) {
        overlay.isHidden = true
        checkImageView.isHidden = true
        reminderImage.isHidden = false
        reminderLabel.isHidden = false
        locationImage.isHidden = false
        locationLabel.isHidden = false
        endTimeLabel.isHidden = false
        
        dateLabel.isHidden = true
        dueLabel.isHidden = true
        
        reminderOtherAnchorConstaint.isActive = false
        reminderLeftAnchorConstaint.isActive = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mma"
        startTimeLabel.text = "\(dateFormatter.string(from: task.startDate))-"
        startTimeLabel.textColor = .white
        
        endTimeLabel.text = dateFormatter.string(from: task.endDate)
        endTimeLabel.textColor = .white
        
        let marginGuide = contentView.layoutMarginsGuide
        let padding: CGFloat = summative ? 22:16
        taskLabel.setDimensions(width: UIScreen.main.bounds.width * 0.55)
        taskLabel.anchor(top: marginGuide.topAnchor,
                         left: marginGuide.leftAnchor,
                         bottom: marginGuide.bottomAnchor,
                         paddingTop: padding,
                         paddingLeft: 10,
                         paddingBottom: padding)
        
        if task.reminder {
            reminderLabel.text = TaskService.shared.setupReminderString(dateOrTime: task.dateOrTime, reminderTime: [task.reminderTime[0], task.reminderTime[1]], reminderDate: task.reminderDate)
            
            //If the user does not specify a location, the reminderImage and label move into the locations place
            if task.location == "" {
                reminderOtherAnchorConstaint.isActive = true
                reminderLeftAnchorConstaint.isActive = false
            }
        } else {
            reminderLabel.isHidden = true
            reminderImage.isHidden = true
        }
        
        reminderLabel.textColor = .white
        locationLabel.textColor = .white
        locationLabel.text = task.location
        
        taskLabel.text = task.title
        taskLabel.textColor = .backgroundColor
        
        //If the user does not specify a label
        if taskLabel.text == "" {
            taskLabel.text = "Untitled"
        }
        
        //If the task is associated with an assignment
        if task.type == "assignment" {
            endTimeLabel.isHidden = true
            startTimeLabel.text = dateFormatter.string(from: task.startDate)
            
            dueLabel.isHidden = false
            dueLabel.text = "Due:"
            dueLabel.textColor = .white
            dueLabel.anchor(left: startTimeLabel.leftAnchor)
            
            startTimeTopAnchorConstaint.isActive = false
            startTimeSummativeAnchorConstraint.isActive = false
            startTimeAssignmentAnchorConstraint.isActive = true
            
            dueLabelTopAnchorConstaint.isActive = true
            dueLabelOtherAnchorConstaint.isActive = false
            
        } else {
            startTimeTopAnchorConstaint.isActive = true
            startTimeSummativeAnchorConstraint.isActive = false
        }
        
        if task.location == "" {
            locationImage.isHidden = true
            locationLabel.isHidden = true
        }
        let color = UIColor.init(red: CGFloat(task.color[0]), green: CGFloat(task.color[1]), blue: CGFloat(task.color[2]), alpha: 1)
        
        taskView.backgroundColor = color
        
        //Changes the layout for the summativeVC cells
        if summative {
            dateLabel.isHidden = false
            dateLabel.text = formatDateNoYear(from: task.startDate)
            dateLabel.textColor = .white
            startTimeLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            endTimeLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            
            startTimeTopAnchorConstaint.isActive = false
            startTimeAssignmentAnchorConstraint.isActive = true
            startTimeSummativeAnchorConstraint.isActive = false
            
            dueLabelTopAnchorConstaint.isActive = false
            dueLabelOtherAnchorConstaint.isActive = true
            
            dateLabel.anchor(left: startTimeLabel.leftAnchor)
            dateLabelTopAnchorConstaint.isActive = false
            dateLabelOtherAnchorConstaint.isActive = true
            
            if task.type == "assignment" {
                dateLabelTopAnchorConstaint.isActive = true
                dateLabelOtherAnchorConstaint.isActive = false
                
                startTimeTopAnchorConstaint.isActive = false
                startTimeAssignmentAnchorConstraint.isActive = false
                startTimeSummativeAnchorConstraint.isActive = true
            }
        }
        
        if task.isComplete {
            overlay.isHidden = false
            checkImageView.isHidden = false
        }
    }
}
