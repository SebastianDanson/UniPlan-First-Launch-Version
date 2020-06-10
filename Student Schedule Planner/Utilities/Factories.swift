//
//  Factories.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-02.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import FSCalendar

//MARK: - Timeline View Controller
func makeTopView(height: CGFloat) -> UIView {
    let topView = UIView()
    topView.backgroundColor = .mainBlue
    let width = UIScreen.main.bounds.width
    topView.setDimensions(width: width, height: height)
    
    return topView
}

func makeCalendar() -> FSCalendar{
    
    let calendar = FSCalendar(frame: CGRect(x: 0, y: UIScreen.main.bounds.height/35, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3))
    calendar.scope = .week
    calendar.appearance.headerDateFormat = "MMMM"
    calendar.appearance.weekdayTextColor = UIColor.backgroundColor
    calendar.appearance.headerTitleColor = UIColor.backgroundColor
    calendar.appearance.titleDefaultColor = UIColor.backgroundColor
    calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 28, weight: .bold)
    calendar.appearance.titleFont = UIFont.systemFont(ofSize: 16, weight: .bold)
    calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 16, weight: .bold)
    calendar.appearance.titleTodayColor = .mainBlue
    calendar.appearance.todayColor = .backgroundColor
    calendar.firstWeekday = 2
    calendar.headerHeight = UIScreen.main.bounds.height/13
    calendar.appearance.headerMinimumDissolvedAlpha = 0
    
    return calendar
}

func makeTitleLabel(withText text: String) -> UILabel{
    let label = UILabel()
    label.text = text
    label.font = UIFont.systemFont(ofSize: 32)
    label.textColor = .backgroundColor
    
    return label
}

func makeAddButton() -> UIButton {
    let addButton = UIButton()
    addButton.setTitle("+", for: .normal)
    addButton.tintColor = .backgroundColor
    addButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
    
    return addButton
}

func makeBackButton() -> UIButton {
    let addButton = UIButton()
    addButton.setImage(UIImage(named: "backbutton"), for: .normal)
    
    return addButton
}

//MARK: - addTask functions
func makeHeading(withText text: String) -> UILabel{
    let heading = UILabel()
    heading.text = text
    heading.textColor = .darkBlue
    heading.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    
    return heading
}

func makeDatePicker(height: CGFloat) -> UIDatePicker{
    let startDatePicker = UIDatePicker()
    startDatePicker.setDimensions(width: UIScreen.main.bounds.width - 40, height: height)
    startDatePicker.backgroundColor = .backgroundColor
    startDatePicker.minimumDate = Date()
    
    return startDatePicker
}

func makeTextField(withPlaceholder text: String) -> UITextField {
    let textField = UITextField()
    textField.setDimensions(width: UIScreen.main.bounds.width - 40, height: 35)
    textField.placeholder = text
    textField.backgroundColor = .lightBlue
    
    return textField
}

func makeSaveButton() -> UIButton{
    let saveButton = UIButton()
    saveButton.setTitle("Save", for: .normal)
    saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
    saveButton.setDimensions(width: 200, height: 50)
    saveButton.layer.cornerRadius = 25
    saveButton.backgroundColor = .mainBlue
    
    return saveButton
}

func makeDeleteButton() -> UIButton {
    let deleteButton = UIButton()
    deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
    deleteButton.tintColor = .backgroundColor
    
    return deleteButton
}

func makeRemindersButton() -> UIButton {
    let reminderButton = UIButton()
    reminderButton.setTitle("None", for: .normal)
    reminderButton.setTitleColor(.darkBlue, for: .normal)
    reminderButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    reminderButton.titleLabel?.alpha = 0.5
    reminderButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
    reminderButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width - 60, bottom: 0, right: 0)
    reminderButton.setDimensions(width: UIScreen.main.bounds.width - 40, height: 35)
    reminderButton.backgroundColor = .lightBlue
    let nextIcon = UIImage(named: "nextMenuButton")
    reminderButton.setImage(nextIcon, for: .normal)
    
    return reminderButton
}

//MARK: - Task Cell
func makeTaskLabel(ofSize size: CGFloat, weight: UIFont.Weight) -> UILabel {
    let taskLabel = UILabel()
    taskLabel.font = UIFont.systemFont(ofSize: size, weight: weight)
    taskLabel.textColor = .darkBlue
    
    return taskLabel
}
