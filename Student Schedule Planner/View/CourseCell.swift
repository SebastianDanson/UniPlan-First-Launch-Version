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
        
        taskView.layer.borderColor = UIColor.clear.cgColor
        taskView.anchor(top: topAnchor,
                        left: leftAnchor,
                        right: rightAnchor,
                        bottom: bottomAnchor,
                        paddingTop: 5,
                        paddingLeft: 10,
                        paddingRight: 10,
                        paddingBottom: 5)
        
        taskLabel.numberOfLines = 0
        taskLabel.lineBreakMode = .byWordWrapping
        taskLabel.setDimensions(width: UIScreen.main.bounds.width * 0.75)
        taskLabel.anchor(top: marginGuide.topAnchor,
                         left: marginGuide.leftAnchor,
                         bottom: marginGuide.bottomAnchor,
                         paddingTop: 15,
                         paddingLeft: 10,
                         paddingBottom: 15)
    }
    
    func update(course: Course) {
        let nextImage = UIImageView(image: nextIcon!)
        taskView.addSubview(nextImage)
        nextImage.centerY(in: taskView)
        nextImage.anchor(right: taskView.rightAnchor, paddingRight:  20)
        
        taskLabel.text = course.title
        taskLabel.textColor = .white
        
        let color = UIColor.init(red: CGFloat(course.color[0]), green: CGFloat(course.color[1]), blue: CGFloat(course.color[2]), alpha: 1)
        taskView.backgroundColor = color
    }
}

