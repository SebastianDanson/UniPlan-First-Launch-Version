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

func makeTableView() -> UITableView {
    let tableView = UITableView()
    tableView.separatorColor = .clear
    tableView.rowHeight = 80
    tableView.isScrollEnabled = true
    
    return tableView
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
    textField.returnKeyType = UIReturnKeyType.done
    let spacerView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
    textField.leftViewMode = UITextField.ViewMode.always
    textField.leftView = spacerView
    
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

func setValueButton(withPlaceholder text: String) -> UIButton {
    let reminderButton = UIButton()
    reminderButton.setTitle(text, for: .normal)
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
func makeLabel(ofSize size: CGFloat, weight: UIFont.Weight) -> UILabel {
    let taskLabel = UILabel()
    taskLabel.font = UIFont.systemFont(ofSize: size, weight: weight)
    taskLabel.textColor = .darkBlue
    
    return taskLabel
}

func makeTaskView() -> UIView {
        let taskView = UIView()
        taskView.layer.shadowColor = UIColor.black.cgColor
        taskView.layer.shadowOpacity = 0.1
        taskView.layer.shadowRadius = 0.5
        taskView.layer.shadowOffset = CGSize(width: 0, height: 2)
        taskView.layer.borderWidth = 1
        taskView.layer.borderColor = UIColor.lightGray.cgColor
        taskView.backgroundColor = .lightBlue
        taskView.layer.cornerRadius = 10
        
        return taskView
}

//MARK: - Course Details View
func makeDayCircleButton(withLetter day: String) -> UIButton {
    let button = UIButton()
    button.setDimensions(width: 26, height: 26)
    button.backgroundColor = .backgroundColor
    button.layer.cornerRadius = 13
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.lightGray.cgColor
    button.setTitle(day, for: .normal)
    button.setTitleColor(.lightGray, for: .normal)
    
    return button
}

func makeStackView(withOrientation axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = axis
    stackView.distribution = .fill
    stackView.alignment = .fill
    stackView.spacing = spacing

    return stackView
}

func makeAddButtonWithFill() -> UIButton {
    let makeAddButtonWithFill = UIButton()
    
    makeAddButtonWithFill.tintColor = .green
    makeAddButtonWithFill.setTitle("+", for: .normal)
    makeAddButtonWithFill.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
    makeAddButtonWithFill.backgroundColor = .mainBlue
    makeAddButtonWithFill.setDimensions(width: 24, height: 24)
    makeAddButtonWithFill.layer.cornerRadius = 12
    makeAddButtonWithFill.imageView?.contentMode = .scaleAspectFit
    makeAddButtonWithFill.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    return makeAddButtonWithFill
}

//MARK: - Add Class View Controller
func makeClassDaysCircleButton(withLetter day: String) -> UIButton {
    let button = UIButton()
    button.backgroundColor = .lightBlue
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.lightGray.cgColor
    button.setTitle(day, for: .normal)
    button.setTitleColor(.darkBlue, for: .normal)
    button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
    button.clipsToBounds = true
    
    
    return button
}

func makeRepeatsButton(withText text: String) -> UIButton{
    let button = UIButton()
      button.setDimensions(height: UIScreen.main.bounds.height/15)
      button.backgroundColor = .lightBlue
      button.layer.borderWidth = 1
      button.layer.borderColor = UIColor.lightGray.cgColor
      button.setTitle(text, for: .normal)
      button.setTitleColor(.darkBlue, for: .normal)
      
      return button
}

func makeSpacerView() -> UIView {
    let view = UIView()
    view.backgroundColor = .backgroundColor
    view.setDimensions(height: UIScreen.main.bounds.height/128)
    
    return view
}
