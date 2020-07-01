//
//  CourseCell.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-11.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import SwipeCellKit

class CourseCell: SwipeTableViewCell {
    
    //MARK: - lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    let taskLabel = makeLabel(ofSize: 28, weight: .bold)
    let nextIcon = UIImage(named: "nextMenuButton")
    let taskView = makeTaskView()
    
    var centerConstraint = NSLayoutConstraint()
    
    //MARK: - setupUI
    func setupViews() {
        backgroundColor = .backgroundColor
        addSubview(taskView)
        taskView.addSubview(taskLabel)
        
        taskView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10, paddingBottom: 5)
        taskView.layer.borderColor = UIColor.clear.cgColor
        
        centerConstraint = taskLabel.centerXAnchor.constraint(equalTo: taskView.centerXAnchor)
        centerConstraint.isActive = true
        taskLabel.centerY(in: taskView)

    }
    
    //MARK: - Actions
    func update(course: Course) {
        let nextImage = UIImageView(image: nextIcon!)
        taskView.addSubview(nextImage)
        nextImage.centerY(in: taskView)
        nextImage.anchor(right: taskView.rightAnchor, paddingRight:  20)

        centerConstraint.isActive = false
        taskLabel.anchor(left: taskView.leftAnchor, paddingLeft: UIScreen.main.bounds.height/30)
        
        taskLabel.text = course.title
        taskLabel.textColor = .white
        
        taskView.backgroundColor = getColor(colorAsInt: course.color)
    }
}

