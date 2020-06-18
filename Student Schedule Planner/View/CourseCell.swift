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
    let taskLabel = makeLabel(ofSize: 22, weight: .bold)
    let nextIcon = UIImage(named: "nextMenuButton")
    let taskView = makeTaskView()


    
    private let circleView: UIView = {
       let view = UIView()
        view.backgroundColor = .mainBlue
        view.setDimensions(width: 16, height: 16)
        view.layer.cornerRadius = 8
        return view
    }()
    
    //MARK: - setupUI
    func setupViews() {
        let nextImage = UIImageView(image: nextIcon!)
        backgroundColor = .backgroundColor
        addSubview(taskView)
        taskView.addSubview(taskLabel)
        taskView.addSubview(nextImage)
        taskView.addSubview(circleView)

        taskView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, paddingBottom: 10)
      
        nextImage.centerY(in: taskView)
        nextImage.anchor(right: taskView.rightAnchor, paddingRight:  20)
        
        taskLabel.centerY(in: taskView)
        taskLabel.anchor(left: taskView.leftAnchor, paddingLeft: 70)
        
        circleView.centerY(in: self)
        circleView.anchor(left: leftAnchor, paddingLeft: 40)
    }
    
    //MARK: - Actions
    func update(course: Course) {
        print(course.title)
        taskLabel.text = course.title
    }
}

