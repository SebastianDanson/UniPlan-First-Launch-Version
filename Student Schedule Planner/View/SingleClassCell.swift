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
    let nextIcon = UIImage(named: "nextMenuButtonGray")
    var locationIcon = UIImage(named: "location")
    let locationLabel = makeLabel(ofSize: 14, weight: .semibold)
    let startTimeLabel = makeLabel(ofSize: 18, weight: .regular)
    let endTimeLabel = makeLabel(ofSize: 18, weight: .regular)
    let classFrequencyLabel = makeLabel(ofSize: 16, weight: .semibold)
    let reminderLabel = makeLabel(ofSize: 14, weight: .semibold)
    let reminderIcon = UIImage(systemName: "alarm.fill")
    let taskView = makeTaskView()
    let scrollView = UIScrollView()
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
        locationImage = UIImageView(image: locationIcon!)
        let nextImage = UIImageView(image: nextIcon!)
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
        
        taskView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 5,
                        paddingLeft: 10, paddingRight: 10, paddingBottom: 5)
        
        classDayStackView.anchor(top: classTypeLabel.bottomAnchor, left: taskView.leftAnchor, paddingTop: 5, paddingLeft: 12)
        
        nextImage.centerY(in: taskView)
        nextImage.anchor(right: taskView.rightAnchor, paddingRight:  UIScreen.main.bounds.height/45)
        
        classTypeLabel.anchor(top: taskView.topAnchor, left: taskView.leftAnchor, paddingTop: 5, paddingLeft: 20)
        
        locationImage.anchor(top: classDayStackView.bottomAnchor, left: taskView.leftAnchor, paddingTop: 7, paddingLeft: 15)
        locationLabel.anchor(top: classDayStackView.bottomAnchor, left: locationImage.rightAnchor,
                             paddingTop: 7, paddingLeft: 4)
        locationImage.setDimensions(width: 15, height: 15)
        
        startTimeLabel.anchor(top: taskView.topAnchor, right: nextImage.leftAnchor, paddingTop: 16, paddingRight: UIScreen.main.bounds.height/36)
        endTimeLabel.anchor(top: startTimeLabel.bottomAnchor,
                            left: startTimeLabel.leftAnchor)
        
        classFrequencyLabel.anchor(top: endTimeLabel.bottomAnchor, left: endTimeLabel.leftAnchor, paddingTop: 5)
        
        reminderImage.anchor(left: taskView.leftAnchor, bottom: taskView.bottomAnchor, paddingLeft: 15, paddingBottom: 5)
        reminderLabel.anchor(left: reminderImage.rightAnchor, bottom: taskView.bottomAnchor, paddingLeft: 5, paddingBottom: 5)
        reminderImage.setDimensions(width: 14, height: 14)
        
        monday.isUserInteractionEnabled = false
        tuesday.isUserInteractionEnabled = false
        wednesday.isUserInteractionEnabled = false
        thursday.isUserInteractionEnabled = false
        friday.isUserInteractionEnabled = false
        saturday.isUserInteractionEnabled = false
        sunday.isUserInteractionEnabled = false
        
    }
    
    //MARK: - Actions
    func update(theClass: SingleClass) {
        classTypeLabel.text = theClass.subType.description
        let course = AllCoursesService.shared.getSelectedCourse()
        taskView.layer.borderColor = getColor(colorAsInt: course?.color ?? 0).cgColor
        
        if let color = course?.color {
            switch color {
            case 0:
                locationIcon = UIImage(named: "locationRed")
            case 1:
                locationIcon = UIImage(named: "locationOrange")
            case 2:
                locationIcon = UIImage(named: "locationYellow")
            case 3:
                locationIcon = UIImage(named: "locationGreen")
            case 4:
                locationIcon = UIImage(named: "locationTurquoise")
            case 5:
                locationIcon = UIImage(named: "locationBlue")
            case 6:
                locationIcon = UIImage(named: "locationDarkBlue")
            case 7:
                locationIcon = UIImage(named: "locationPurple")
            default:
                break
            }
        }
        locationImage.image = locationIcon
        
        reminderImage.tintColor = getColor(colorAsInt: course?.color ?? 0)
        monday.unhighlight(courseColor: 0)
        tuesday.unhighlight(courseColor: 0)
        wednesday.unhighlight(courseColor: 0)
        thursday.unhighlight(courseColor: 0)
        friday.unhighlight(courseColor: 0)
        saturday.unhighlight(courseColor: 0)
        sunday.unhighlight(courseColor: 0)
        
        for(index, day) in theClass.classDays.enumerated() {
            
            if day == 1 {
                switch index {
                case 0:
                    sunday.highlight(courseColor: 0)
                case 1:
                    monday.highlight(courseColor: 0)
                case 2:
                    tuesday.highlight(courseColor: 0)
                case 3:
                    wednesday.highlight(courseColor: 0)
                case 4:
                    thursday.highlight(courseColor: 0)
                case 5:
                    friday.highlight(courseColor: 0)
                case 6:
                    saturday.highlight(courseColor: 0)
                default:
                    break
                }
            }
        }
        
        locationLabel.text = theClass.location == "" ? "Not set": theClass.location
        
        startTimeLabel.text = "\(formatTime(from: theClass.startTime))-"
        
        endTimeLabel.text = formatTime(from: theClass.endTime)
        
        let repeats = theClass.repeats
        classFrequencyLabel.text = repeats == "Never Repeats" ? repeats : "Every \(repeats)"
        
        reminderLabel.text = SingleClassService.shared.setupReminderString(theClass: theClass)
    }
}

