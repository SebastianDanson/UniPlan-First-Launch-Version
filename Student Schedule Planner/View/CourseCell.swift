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
    
//    private let circleView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .mainBlue
//        view.setDimensions(width: 24, height: 24)
//        view.layer.cornerRadius = 12
//        return view
//    }()
    
    //MARK: - setupUI
    func setupViews() {
        let nextImage = UIImageView(image: nextIcon!)
        backgroundColor = .backgroundColor
        addSubview(taskView)
        taskView.addSubview(taskLabel)
        taskView.addSubview(nextImage)
       // taskView.addSubview(circleView)
        
        taskView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10, paddingBottom: 5)
        
        nextImage.centerY(in: taskView)
        nextImage.anchor(right: taskView.rightAnchor, paddingRight:  20)
        
        taskLabel.centerY(in: taskView)
        taskLabel.anchor(left: taskView.leftAnchor, paddingLeft: UIScreen.main.bounds.height/30)
        
       // circleView.centerY(in: self)
        //circleView.anchor(left: leftAnchor, paddingLeft: 40)
    }
    
    //MARK: - Actions
    func update(course: Course) {
        taskLabel.text = course.title
        taskLabel.textColor = .white
        
        switch course.color {
        case 0:
            taskView.backgroundColor = .alizarin
        case 1:
            taskView.backgroundColor = .carrot
        case 2:
            taskView.backgroundColor = .sunflower
        case 3:
            taskView.backgroundColor = .emerald
        case 4:
            taskView.backgroundColor = .turquoise
        case 5:
            taskView.backgroundColor = .riverBlue
        case 6:
            taskView.backgroundColor = .midnightBlue
        case 7:
            taskView.backgroundColor = .amethyst
        default:
            break
        }
    }
}

