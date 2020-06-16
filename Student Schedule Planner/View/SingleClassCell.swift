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
    let nextIcon = UIImage(named: "nextMenuButton")
    let locationIcon = UIImage(named: "location")
    let locationLabel = makeLabel(ofSize: 14, weight: .semibold)
    let startTimeLabel = makeLabel(ofSize: 18, weight: .regular)
    let endTimeLabel = makeLabel(ofSize: 18, weight: .regular)
    let classFrequencyLabel = makeLabel(ofSize: 16, weight: .semibold)
    let reminderLabel = makeLabel(ofSize: 14, weight: .regular)
    let reminderIcon = UIImage(systemName: "alarm")
    let taskView = makeTaskView()
    
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
        let locationImage = UIImageView(image: locationIcon!)
        let reminderImage = UIImageView(image: reminderIcon!)

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

        taskView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 10,
                        paddingLeft: 10, paddingRight: 10, paddingBottom: 10)

        classDayStackView.anchor(top: classTypeLabel.bottomAnchor, left: taskView.leftAnchor, paddingTop: 5, paddingLeft: 12)

        nextImage.centerY(in: taskView)
        nextImage.anchor(right: taskView.rightAnchor, paddingRight:  UIScreen.main.bounds.height/45)

        classTypeLabel.text = "Class"
        classTypeLabel.anchor(top: taskView.topAnchor, left: taskView.leftAnchor, paddingTop: 5, paddingLeft: 20)

        locationImage.anchor(top: classDayStackView.bottomAnchor, left: taskView.leftAnchor, paddingTop: 7, paddingLeft: 15)
        locationLabel.anchor(top: classDayStackView.bottomAnchor, left: locationImage.rightAnchor,
                             paddingTop: 7, paddingLeft: 5)
        locationImage.setDimensions(width: 9, height: 13)

        locationLabel.text = "Macdonald Building 424"

        startTimeLabel.anchor(top: taskView.topAnchor, right: nextImage.leftAnchor, paddingTop: 16, paddingRight: UIScreen.main.bounds.height/36)
        endTimeLabel.anchor(top: startTimeLabel.bottomAnchor,
                                left: startTimeLabel.leftAnchor)
        startTimeLabel.text = "12:00PM-"
        endTimeLabel.text = "01:00PM"

        classFrequencyLabel.anchor(top: endTimeLabel.bottomAnchor, left: endTimeLabel.leftAnchor, paddingTop: 5)
        classFrequencyLabel.text = "Every week"

        reminderImage.anchor(left: taskView.leftAnchor, bottom: taskView.bottomAnchor, paddingLeft: 15, paddingBottom: 5)
        reminderLabel.anchor(left: reminderImage.rightAnchor, bottom: taskView.bottomAnchor, paddingLeft: 5, paddingBottom: 5)
        reminderLabel.text = "0 hours, 10min before"
        reminderImage.setDimensions(width: 11, height: 13)

    }

    //MARK: - Actions
    func update(theClass: SingleClass) {
        classTypeLabel.text = theClass.type

        //Highlight class Days
        for (index, day) in theClass.classDays.enumerated() {
            if day == 1 {
                switch index {
                case 0:
                    sunday.highlight()
                case 1:
                    monday.highlight()
                case 2:
                    tuesday.highlight()
                case 3:
                    wednesday.highlight()
                case 4:
                    thursday.highlight()
                case 5:
                    friday.highlight()
                case 6:
                    saturday.highlight()
                default:
                    break
                }
            }
        }
        
        locationLabel.text = theClass.location
        startTimeLabel.text = "\(formatTime(from: theClass.startTime))-"
        endTimeLabel.text = formatTime(from: theClass.endTime)
       
        let repeats = theClass.repeats
        classFrequencyLabel.text = repeats == "Never Repeats" ? repeats : "Every \(repeats)"
        
        reminderLabel.text = SingleClassService.shared.setupReminderString(theClass: theClass)
    }
}

