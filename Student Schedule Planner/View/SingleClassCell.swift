//
//  ClassCell.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-13.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import SwipeCellKit

class SingleClassCell: SwipeTableViewCell {
    
    //MARK: - lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    let classTypeLabel = makeLabel(ofSize: 14, weight: .regular)
    let classDayStackView = makeStackView(withOrientation: .horizontal, spacing: UIScreen.main.bounds.height/179)
    
    var locationIcon = UIImage(named: "location")
    let locationLabel = makeLabel(ofSize: 14, weight: .semibold)
    let nextIcon = UIImage(named: "nextMenuButtonGray")
    
    let startTimeLabel = makeLabel(ofSize: 18, weight: .regular)
    let endTimeLabel = makeLabel(ofSize: 18, weight: .regular)
    
    let classFrequencyLabel = makeLabel(ofSize: 16, weight: .semibold)
    
    let reminderLabel = makeLabel(ofSize: 14, weight: .semibold)
    let reminderIcon = UIImage(systemName: "alarm.fill")
    
    let taskView = makeTaskView()
    
    var reminderImage = UIImageView()
    var locationImage = UIImageView()
    
    //Day Circles
    let sunday = makeDayCircleButton(withLetter: "S")
    let monday = makeDayCircleButton(withLetter: "M")
    let tuesday = makeDayCircleButton(withLetter: "T")
    let wednesday = makeDayCircleButton(withLetter: "W")
    let thursday = makeDayCircleButton(withLetter: "T")
    let friday = makeDayCircleButton(withLetter: "F")
    let saturday = makeDayCircleButton(withLetter: "S")
    
    //MARK: - setupUI
    func setupViews() {
        let nextImage = UIImageView(image: nextIcon!)
        locationImage = UIImageView(image: locationIcon!)
        reminderImage = UIImageView(image: reminderIcon!)
        reminderImage.tintColor = .mainBlue
        
        backgroundColor = .backgroundColor
        
        addSubview(taskView)
        taskView.addSubview(classDayStackView)
        taskView.addSubview(nextImage)
        taskView.addSubview(classTypeLabel)
        taskView.addSubview(locationImage)
        taskView.addSubview(locationLabel)
        taskView.addSubview(startTimeLabel)
        taskView.addSubview(endTimeLabel)
        taskView.addSubview(classFrequencyLabel)
        taskView.addSubview(reminderLabel)
        taskView.addSubview(reminderImage)
        
        classDayStackView.addArrangedSubview(sunday)
        classDayStackView.addArrangedSubview(monday)
        classDayStackView.addArrangedSubview(tuesday)
        classDayStackView.addArrangedSubview(wednesday)
        classDayStackView.addArrangedSubview(thursday)
        classDayStackView.addArrangedSubview(friday)
        classDayStackView.addArrangedSubview(saturday)
        
        taskView.layer.borderWidth = 2.5
        taskView.anchor(top: topAnchor,
                        left: leftAnchor,
                        right: rightAnchor,
                        bottom: bottomAnchor,
                        paddingTop: 5,
                        paddingLeft: 10,
                        paddingRight: 10,
                        paddingBottom: 5)
        
        classDayStackView.anchor(top: classTypeLabel.bottomAnchor,
                                 left: taskView.leftAnchor,
                                 paddingTop: 5,
                                 paddingLeft: 12)
        
        nextImage.centerY(in: taskView)
        nextImage.anchor(right: taskView.rightAnchor, paddingRight:  UIScreen.main.bounds.height/45)
        
        locationImage.setDimensions(width: 15, height: 15)
        locationImage.anchor(top: classDayStackView.bottomAnchor,
                             left: taskView.leftAnchor,
                             paddingTop: 7,
                             paddingLeft: 15)
        
        locationLabel.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 0.55).isActive = true
        locationLabel.anchor(top: classDayStackView.bottomAnchor,
                             left: locationImage.rightAnchor,
                             paddingTop: 7,
                             paddingLeft: 4)
        
        classTypeLabel.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width - 50).isActive = true
        startTimeLabel.anchor(top: classDayStackView.topAnchor,
                              right: nextImage.leftAnchor,
                              paddingTop: -5,
                              paddingRight: UIScreen.main.bounds.height/36)
        
        endTimeLabel.anchor(top: startTimeLabel.bottomAnchor, left: startTimeLabel.leftAnchor)
        
        classFrequencyLabel.anchor(left: endTimeLabel.leftAnchor,
                                   bottom: taskView.bottomAnchor,
                                   paddingBottom: 10)
        
        reminderImage.setDimensions(width: 14, height: 14)
        reminderImage.anchor(left: taskView.leftAnchor,
                             bottom: taskView.bottomAnchor,
                             paddingLeft: 15,
                             paddingBottom: 5)
        
        reminderLabel.anchor(left: reminderImage.rightAnchor,
                             bottom: taskView.bottomAnchor,
                             paddingLeft: 5,
                             paddingBottom: 5)
        
        //User cannot click on any of the day buttons
        monday.isUserInteractionEnabled = false
        tuesday.isUserInteractionEnabled = false
        wednesday.isUserInteractionEnabled = false
        thursday.isUserInteractionEnabled = false
        friday.isUserInteractionEnabled = false
        saturday.isUserInteractionEnabled = false
        sunday.isUserInteractionEnabled = false
    }
    
    //MARK: - Actions
    func update(theClass: SingleClass? = nil, routine: Routine? = nil) {
        if let theClass = theClass {
            
               classTypeLabel.anchor(top: taskView.topAnchor,
                                     left: taskView.leftAnchor,
                                     paddingTop: 5,
                                     paddingLeft: 20)
            
            let course = AllCoursesService.shared.getSelectedCourse()
            let color = UIColor.init(red: CGFloat(course?.color[0] ?? 0), green: CGFloat(course?.color[1] ?? 0), blue: CGFloat(course?.color[2] ?? 0), alpha: 1)
            
            let tintedLocationIcon = locationIcon?.withRenderingMode(.alwaysTemplate)
            locationImage.image = tintedLocationIcon
            locationImage.tintColor = color
            
            classTypeLabel.text = theClass.subType.description
            
            taskView.layer.borderColor = color.cgColor
            
            reminderImage.tintColor = color
            
            locationLabel.text = theClass.location == "" ? "Not set": theClass.location
            
            startTimeLabel.text = "\(formatTime(from: theClass.startTime))-"
            endTimeLabel.text = formatTime(from: theClass.endTime)
            
            monday.unhighlight(courseColor: color)
            tuesday.unhighlight(courseColor: color)
            wednesday.unhighlight(courseColor: color)
            thursday.unhighlight(courseColor: color)
            friday.unhighlight(courseColor: color)
            saturday.unhighlight(courseColor: color)
            sunday.unhighlight(courseColor: color)
            
            //Highlights the days of the class
            for (index, day) in theClass.classDays.enumerated() {
                if day == 1 {
                    switch index {
                    case 0:
                        sunday.highlight(courseColor: color)
                        SingleClassService.shared.setDay(day: 0)
                    case 1:
                        monday.highlight(courseColor: color)
                        SingleClassService.shared.setDay(day: 1)
                    case 2:
                        tuesday.highlight(courseColor: color)
                        SingleClassService.shared.setDay(day: 2)
                    case 3:
                        wednesday.highlight(courseColor: color)
                        SingleClassService.shared.setDay(day: 3)
                    case 4:
                        thursday.highlight(courseColor: color)
                        SingleClassService.shared.setDay(day: 4)
                    case 5:
                        friday.highlight(courseColor: color)
                        SingleClassService.shared.setDay(day: 5)
                    case 6:
                        saturday.highlight(courseColor: color)
                        SingleClassService.shared.setDay(day: 6)
                    default:
                        break
                    }
                }
            }
            let repeats = theClass.repeats
            classFrequencyLabel.text = repeats == "Never Repeats" ? repeats : "Every \(repeats)"
            
            if theClass.reminder {
                reminderLabel.text = TaskService.shared.setupReminderString(dateOrTime: 0, reminderTime: [theClass.reminderTime[0], theClass.reminderTime[1]], reminderDate: Date())
            } else {
                reminderLabel.text = "None"
            }
        }
        
        if let routine = routine {
            let color = UIColor.init(red: CGFloat(routine.color[0]), green: CGFloat(routine.color[1]), blue: CGFloat(routine.color[2]), alpha: 1)
            
            let tintedLocationIcon = locationIcon?.withRenderingMode(.alwaysTemplate)
            locationImage.image = tintedLocationIcon
            locationImage.tintColor = color
            
            classTypeLabel.text = routine.title == "" ? "Untitled": routine.title
            classTypeLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            
            taskView.layer.borderColor = color.cgColor
            
            reminderImage.tintColor = color
            
            locationLabel.text = routine.location == "" ? "Not set": routine.location
            
            startTimeLabel.text = "\(formatTime(from: routine.startTime))-"
            endTimeLabel.text = formatTime(from: routine.endTime)
            
            taskView.layer.borderColor = color.cgColor
            monday.unhighlight(courseColor: color)
            tuesday.unhighlight(courseColor: color)
            wednesday.unhighlight(courseColor: color)
            thursday.unhighlight(courseColor: color)
            friday.unhighlight(courseColor: color)
            saturday.unhighlight(courseColor: color)
            sunday.unhighlight(courseColor: color)
            
            
            classTypeLabel.anchor(top: taskView.topAnchor,
                                  left: classDayStackView.leftAnchor,
                                  paddingTop: 10,
                                  paddingLeft: 5)
            
            //Highlights the days of the class
            for (index, day) in routine.days.enumerated() {
                if day == 1 {
                    switch index {
                    case 0:
                        sunday.highlight(courseColor: color)
                        SingleClassService.shared.setDay(day: 0)
                    case 1:
                        monday.highlight(courseColor: color)
                        SingleClassService.shared.setDay(day: 1)
                    case 2:
                        tuesday.highlight(courseColor: color)
                        SingleClassService.shared.setDay(day: 2)
                    case 3:
                        wednesday.highlight(courseColor: color)
                        SingleClassService.shared.setDay(day: 3)
                    case 4:
                        thursday.highlight(courseColor: color)
                        SingleClassService.shared.setDay(day: 4)
                    case 5:
                        friday.highlight(courseColor: color)
                        SingleClassService.shared.setDay(day: 5)
                    case 6:
                        saturday.highlight(courseColor: color)
                        SingleClassService.shared.setDay(day: 6)
                    default:
                        break
                    }
                }
            }
            let repeats = routine.repeats
            classFrequencyLabel.text = repeats == "Never Repeats" ? repeats : "Every \(repeats)"
            
            if routine.reminder {
                reminderLabel.text = TaskService.shared.setupReminderString(dateOrTime: 0, reminderTime: [routine.reminderTime[0], routine.reminderTime[1]], reminderDate: Date())
            } else {
                reminderLabel.text = "None"
            }
        }
    }
}


