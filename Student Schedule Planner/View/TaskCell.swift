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
        let marginGuide = contentView.layoutMarginsGuide

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
        
        taskView.layer.borderWidth = 0
        taskView.backgroundColor = .backgroundColor
        taskLabel.lineBreakMode = .byWordWrapping
        taskLabel.numberOfLines = 0
        taskLabel.setDimensions(width: UIScreen.main.bounds.width * 0.60)

        taskView.anchor(top: topAnchor, bottom: bottomAnchor,
                        paddingTop: 5, paddingBottom: 5)
        taskView.setDimensions(width: UIScreen.main.bounds.width - 20)
        taskView.centerX(in: self)
        
        nextImage.centerY(in: taskView)
        nextImage.anchor(right: taskView.rightAnchor, paddingRight:  10)

        reminderImage.anchor(bottom: taskView.bottomAnchor, paddingBottom: 4)
        reminderImage.tintColor = .white
        reminderImage.setDimensions(width: 15, height: 15)
        reminderLabel.anchor(left: reminderImage.rightAnchor, bottom: taskView.bottomAnchor, paddingLeft: 2, paddingBottom: 4)
        
        locationImage.anchor(left: taskLabel.leftAnchor, bottom: taskView.bottomAnchor, paddingBottom: 4)
        
        locationImage.setDimensions(width: 15, height: 15)
        locationLabel.anchor(left: locationImage.rightAnchor, bottom: taskView.bottomAnchor,
                                    paddingLeft: 2,
                                    paddingBottom: 4)
        locationLabel.anchor(left: locationImage.rightAnchor,
        bottom: taskView.bottomAnchor,
        paddingLeft: 2,
        paddingBottom: 4)
        
        reminderLeftAnchorConstaint = reminderImage.leftAnchor.constraint(equalTo: locationLabel.rightAnchor, constant: 10)
        reminderOtherAnchorConstaint = reminderImage.leftAnchor.constraint(equalTo: locationImage.leftAnchor)
        reminderLeftAnchorConstaint.isActive = true

        startTimeLabel.anchor(right: nextImage.leftAnchor, paddingRight:  10)
        
        endTimeLabel.anchor(top: startTimeLabel.bottomAnchor, left: startTimeLabel.leftAnchor, paddingBottom: 20)
        startTimeTopAnchorConstaint = startTimeLabel.centerYAnchor.constraint(equalTo: taskView.centerYAnchor, constant: -10)
        startTimeTopAnchorConstaint.isActive = true
        startTimeOtherAnchorConstaint = startTimeLabel.topAnchor.constraint(equalTo: taskView.topAnchor, constant: 16)
        startTimeSummativeAnchorConstraint = startTimeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 2)
        

        taskLabel.anchor(top: marginGuide.topAnchor, left: marginGuide.leftAnchor, bottom: marginGuide.bottomAnchor, paddingTop: 15, paddingLeft: 10, paddingBottom: 15)

    }
    
    //MARK: - Actions
    func update(task: Task, summative: Bool) {
        reminderImage.isHidden = false
       reminderLabel.isHidden = false
        locationImage.isHidden = false
        locationLabel.isHidden = false
        dateLabel.isHidden = true
        reminderOtherAnchorConstaint.isActive = false
        reminderLeftAnchorConstaint.isActive = true

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mma"
        startTimeLabel.text = "\(dateFormatter.string(from: task.startDate))-"
        startTimeLabel.textColor = .white
        
        endTimeLabel.text = dateFormatter.string(from: task.endDate)
        endTimeLabel.textColor = .white

        if task.reminder {
            reminderLabel.text = TaskService.shared.setupReminderString(dateOrTime: task.dateOrTime, reminderTime: [task.reminderTime[0], task.reminderTime[1]], reminderDate: task.reminderDate)
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
        
        if taskLabel.text == "" {
            taskLabel.text = "Untitled"
        }

        if task.type == "assignment" {
            endTimeLabel.isHidden = true
            startTimeLabel.text = dateFormatter.string(from: task.startDate)
            taskView.addSubview(dueLabel)
            dueLabel.text = "Due:"
            dueLabel.textColor = .white
            let paddingTop: CGFloat = summative ? 5:10
            dueLabel.anchor(top: taskView.topAnchor, left: startTimeLabel.leftAnchor, paddingTop: paddingTop)
        } else {
            startTimeOtherAnchorConstaint.isActive = false
            startTimeTopAnchorConstaint.isActive = true
            startTimeSummativeAnchorConstraint.isActive = false
        }
        
        if task.location == "" {
            locationImage.isHidden = true
            locationLabel.isHidden = true
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
