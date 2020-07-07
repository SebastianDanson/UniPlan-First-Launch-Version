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
        
    //MARK: - setupUI
    func setupViews() {
        let marginGuide = contentView.layoutMarginsGuide

        backgroundColor = .backgroundColor
        contentView.addSubview(taskView)
        taskView.addSubview(taskLabel)
        
        taskView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10, paddingBottom: 5)
        taskView.layer.borderColor = UIColor.clear.cgColor
        
        taskLabel.numberOfLines = 0
        taskLabel.lineBreakMode = .byWordWrapping
        taskLabel.anchor(top: marginGuide.topAnchor, left: marginGuide.leftAnchor, bottom: marginGuide.bottomAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10)
        taskLabel.setDimensions(width: UIScreen.main.bounds.width * 0.75)


    }
    
    //MARK: - Actions
    func update(course: Course) {
        let nextImage = UIImageView(image: nextIcon!)
        taskView.addSubview(nextImage)
        nextImage.centerY(in: taskView)
        nextImage.anchor(right: taskView.rightAnchor, paddingRight:  20)


        taskLabel.text = course.title
        taskLabel.textColor = .white
        
        taskView.backgroundColor = TaskService.shared.getColor(colorAsInt: course.color)
    }
}

