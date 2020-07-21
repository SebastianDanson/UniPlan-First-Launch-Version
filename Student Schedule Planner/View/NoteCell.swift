//
//  NoteCell.swift
//  UniPlan
//
//  Created by Student on 2020-07-11.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import SwipeCellKit

class NoteCell: SwipeTableViewCell {
    
    //MARK: - lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    let titleLabel = makeLabel(ofSize: 20, weight: .bold)
    let notes = makeLabel(ofSize: 14, weight: .regular)
    let nextIcon = UIImage(named: "nextMenuButton")
    let taskView = makeTaskView()
    
    //MARK: - setupUI
    func setupViews() {
        
        let marginGuide = contentView.layoutMarginsGuide
        
        backgroundColor = backgroundColor
        
        contentView.addSubview(taskView)
        taskView.addSubview(titleLabel)
        taskView.addSubview(notes)
        
        taskView.backgroundColor = backgroundColor
        taskView.layer.borderColor = UIColor.clear.cgColor
        taskView.layer.borderWidth = 2.5
        taskView.anchor(top: topAnchor,
                        left: leftAnchor,
                        right: rightAnchor,
                        bottom: bottomAnchor,
                        paddingTop: 5,
                        paddingLeft: 10,
                        paddingRight: 10,
                        paddingBottom: 5)
        
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.setDimensions(width: UIScreen.main.bounds.width * 0.875)
        titleLabel.anchor(top: marginGuide.topAnchor,
                          left: marginGuide.leftAnchor,
                          bottom: notes.topAnchor,
                          paddingTop: 5,
                          paddingLeft: 10)
        
        notes.setDimensions(width: UIScreen.main.bounds.width * 0.875)
        notes.anchor(top: titleLabel.bottomAnchor,
                     left: titleLabel.leftAnchor,
                     bottom: marginGuide.bottomAnchor,
                     paddingBottom: 2)
    }
    
    func update(note: Note) {
        let course = AllCoursesService.shared.getSelectedCourse()
        let nextImage = UIImageView(image: nextIcon!)
        
        taskView.addSubview(nextImage)
        nextImage.centerY(in: taskView)
        nextImage.anchor(right: taskView.rightAnchor, paddingRight:  20)
        
        titleLabel.text = note.title
        notes.text = note.notes
        
        if let course = course {
            let color = UIColor.init(red: CGFloat(course.color[0]), green: CGFloat(course.color[1]), blue: CGFloat(course.color[2]), alpha: 1)
            taskView.layer.borderColor = color.cgColor
            
        } else {
            let color = UIColor.init(red: CGFloat(note.color[0]), green: CGFloat(note.color[1]), blue: CGFloat(note.color[2]), alpha: 1)
            taskView.layer.borderColor = color.cgColor
            
        }
    }
}
