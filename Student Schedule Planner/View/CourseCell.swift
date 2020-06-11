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
    let taskLabel = makeTaskLabel(ofSize: 22, weight: .bold)
    let nextIcon = UIImage(named: "nextMenuButton")
    let durationStartLabel = makeTaskLabel(ofSize: 14, weight: .regular)
    let durationEndLabel = makeTaskLabel(ofSize: 14, weight: .regular)
    let taskView = makeTaskView()
    let nextClassLabel = makeTaskLabel(ofSize: 14, weight: .bold)
    let nextAsignmentLabel = makeTaskLabel(ofSize: 14, weight: .bold)
    let nextAsignmentDateLabel = makeTaskLabel(ofSize: 14, weight: .regular)

    
    private let circleView: UIView = {
       let view = UIView()
        view.backgroundColor = .mainBlue
        view.setDimensions(width: 18, height: 18)
        view.layer.cornerRadius = 9
        return view
    }()
    
    //MARK: - setupUI
    func setupViews() {
        let nextImage = UIImageView(image: nextIcon!)
        backgroundColor = .backgroundColor
        addSubview(taskView)
        taskView.addSubview(taskLabel)
        taskView.addSubview(durationStartLabel)
        taskView.addSubview(durationEndLabel)
        taskView.addSubview(nextImage)
        taskView.addSubview(circleView)
        taskView.addSubview(nextClassLabel)
        taskView.addSubview(nextAsignmentLabel)
        taskView.addSubview(nextAsignmentDateLabel)

        
        nextClassLabel.anchor(top: taskView.topAnchor, left: durationStartLabel.leftAnchor, paddingTop: 4)
        nextAsignmentLabel.anchor(top: durationStartLabel.bottomAnchor, left: durationStartLabel.leftAnchor, paddingTop: 5)

        durationStartLabel.anchor(top: nextClassLabel.bottomAnchor, right: durationEndLabel.leftAnchor, paddingTop: 0, paddingRight: 5)
        durationEndLabel.anchor(top: nextClassLabel.bottomAnchor, right: nextImage.rightAnchor, paddingTop: 0, paddingRight: 25)
        nextAsignmentDateLabel.anchor(top: nextAsignmentLabel.bottomAnchor, left: durationStartLabel.leftAnchor)

        taskView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10, paddingBottom: 5)
        nextImage.centerY(in: taskView)
        nextImage.anchor(right: taskView.rightAnchor, paddingRight:  20)
                
        nextAsignmentDateLabel.text = "June 12, 12:00AM"
        taskLabel.text = "HEY"
        durationStartLabel.text = "05:30PM-"
        durationEndLabel.text = "06:30PM"
        nextClassLabel.text = "Next Class:"
        nextAsignmentLabel.text = "Next Assignment"
        
        taskLabel.centerY(in: taskView)
        taskLabel.anchor(left: taskView.leftAnchor, paddingLeft: 70)
        
        circleView.centerY(in: self)
        circleView.anchor(left: leftAnchor, paddingLeft: 40)
    }
    
    //MARK: - Actions
//    func update(task: Task) {
//    }
    
}

