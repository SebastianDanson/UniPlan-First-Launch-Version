//
//  Factories.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-02.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import FSCalendar
import RealmSwift

let realm = try! Realm()

//MARK: - Timeline View Controller

//The blue section at the top of each VC
func makeTopView(height: CGFloat) -> UIView {
    let topView = UIView()
    topView.backgroundColor = .mainBlue
    let width = UIScreen.main.bounds.width
    topView.setDimensions(width: width, height: height)
    
    return topView
}

//The Calendar on TimelineVC
func makeCalendar() -> FSCalendar{
    let calendar = FSCalendar(frame: CGRect(x: 0, y: UIScreen.main.bounds.height/38, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2.5))
    calendar.scope = .week
    calendar.appearance.headerDateFormat = "MMM Y"
    calendar.appearance.weekdayTextColor = UIColor.backgroundColor
    calendar.appearance.headerTitleColor = UIColor.backgroundColor
    calendar.appearance.titleDefaultColor = UIColor.backgroundColor
    calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24, weight: .bold)
    calendar.appearance.titleFont = UIFont.systemFont(ofSize: 16, weight: .bold)
    calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 14, weight: .bold)
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

func makeBackButton() -> UIButton {
    let backButton = UIButton()
    backButton.setDimensions(width: 40, height: 40)
    backButton.setImage(UIImage(named: "backbutton"), for: .normal)
    
    return backButton
}

func makeTableView(withRowHeight height: CGFloat) -> UITableView {
    let tableView = UITableView()
    tableView.separatorColor = .clear
    tableView.rowHeight = height
    tableView.isScrollEnabled = true
    
    return tableView
}

//MARK: - Add Task View Controller
func makeHeading(withText text: String) -> UILabel{
    let heading = UILabel()
    heading.text = text
    heading.textColor = .darkBlue
    heading.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    
    return heading
}

func makeDateAndTimePicker(height: CGFloat) -> UIDatePicker{
    let picker = UIDatePicker()
    picker.setDimensions(width: UIScreen.main.bounds.width - 40, height: height)
    picker.backgroundColor = .backgroundColor
    picker.minimumDate = Date()
    
    return picker
}

func makeTextField(withPlaceholder text: String, height: CGFloat) -> UITextField {
    let textField = UITextField()
    textField.setDimensions(width: UIScreen.main.bounds.width - 40, height: height)
    textField.placeholder = text
    textField.backgroundColor = .clear
    textField.textColor = .darkBlue
    textField.layer.borderColor = UIColor.mainBlue.cgColor
    textField.layer.borderWidth = 2
    textField.layer.cornerRadius = 5
    textField.returnKeyType = UIReturnKeyType.done
    let spacerView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
    textField.leftViewMode = UITextField.ViewMode.always
    textField.leftView = spacerView
    textField.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    
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

func makeSaveLabelButton() -> UIButton {
    let button = UIButton()
    button.setTitle("Save", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    button.setTitleColor(.white, for: .normal)
    button.setDimensions(width: 50, height: 50)
    
    return button
}
//Trash Button
func makeDeleteButton() -> UIButton {
    let deleteButton = UIButton()
    deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
    deleteButton.tintColor = .backgroundColor
    deleteButton.setDimensions(width: 40, height: 40)
    
    return deleteButton
}

//Buttons that take you to AnotherVC where you set some value such as a reminder
func setValueButton(withPlaceholder text: String, height: CGFloat, width: CGFloat? = nil) -> UIButton {
    let button = UIButton()
    button.setTitle(text, for: .normal)
    button.setTitleColor(.darkBlue, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width - 65, bottom: 0, right: 0)
    button.setDimensions(width: width ?? UIScreen.main.bounds.width - 40, height: height)
    button.backgroundColor = .clear
    button.layer.borderColor = UIColor.mainBlue.cgColor
    button.layer.borderWidth = 2
    button.layer.cornerRadius = 5
    let nextIcon = UIImage(named: "nextMenuButtonGray")
    button.setImage(nextIcon, for: .normal)
    
    return button
}

//Buttons with an Image on its left side
func makeButtonWithImage(withPlaceholder text: String, imageName: String, height: CGFloat? = nil) -> UIButton {
    let button = UIButton()
    button.setTitle(text, for: .normal)
    button.setTitleColor(.darkBlue, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 42, bottom: 0, right: 0)
    button.setDimensions(width: UIScreen.main.bounds.width - 40, height: height ?? 45)
    button.backgroundColor = .clear
    button.layer.borderColor = UIColor.mainBlue.cgColor
    button.layer.borderWidth = 2
    button.layer.cornerRadius = 5
    let calendarIcon = UIImage(systemName: imageName)
    let imageView = UIImageView(image: calendarIcon)
    button.addSubview(imageView)
    imageView.centerY(in: button)
    imageView.anchor(left: button.leftAnchor, paddingLeft: 10)
    imageView.setDimensions(width: 30, height: 30)
    imageView.tintColor = .mainBlue
    
    return button
}

//Views that move up and down when buttons are clicked
func makeAnimatedView() -> UIView {
    let view = UIView()
    view.backgroundColor = .backgroundColor
    view.setDimensions(width: UIScreen.main.bounds.width-40)
    return view
}

//MARK: - Task Cell
func makeLabel(ofSize size: CGFloat, weight: UIFont.Weight) -> UILabel {
    let taskLabel = UILabel()
    taskLabel.font = UIFont.systemFont(ofSize: size, weight: weight)
    taskLabel.textColor = .darkBlue
    
    return taskLabel
}

//View where all cell Views are added
func makeTaskView() -> UIView {
    let taskView = UIView()
    taskView.layer.cornerRadius = 10
    
    return taskView
}

//MARK: - Course Details View
//Circular button representing a day of the week
func makeDayCircleButton(withLetter day: String) -> UIButton {
    let button = UIButton()
    button.setDimensions(width: 26, height: 26)
    button.layer.cornerRadius = 13
    button.setTitle(day, for: .normal)
    
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

func makeCornerAddButton(withDiameter diameter: CGFloat? = nil) -> UIButton {
    let addButton = UIButton()
    let addButtonImage = UIImage(systemName: "plus.circle.fill")
    let addButtonView = UIImageView(image: addButtonImage!)
    
    addButton.addSubview(addButtonView)
    
    addButtonView.setDimensions(width: diameter ?? 70, height: diameter ?? 70)
    addButton.setDimensions(width: diameter ?? 70, height: diameter ?? 70)
    addButton.tintColor = .lightMidnightBlue
    
    return addButton
}

//MARK: - Add Class
//Days when the class occurs
func makeClassDaysCircleButton(withLetter day: String) -> UIButton {
    let button = UIButton()
    button.setTitle(day, for: .normal)
    button.setDimensions(width: (UIScreen.main.bounds.width - 85)/7, height: (UIScreen.main.bounds.width - 85)/7)
    button.layer.cornerRadius = (UIScreen.main.bounds.width - 85)/14
    button.clipsToBounds = true
    button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
    button.unhighlight()
    
    return button
}

func makeSpacerView(height: CGFloat) -> UIView {
    let view = UIView()
    view.backgroundColor = .backgroundColor
    view.setDimensions(height: height)
    
    return view
}

func makeTimePicker(withHeight height: CGFloat) -> UIDatePicker {
    let timePicker = UIDatePicker()
    timePicker.datePickerMode = .time
    timePicker.setDimensions(height: height)
    
    return timePicker
}

func makeDatePicker(withHeight height: CGFloat) -> UIDatePicker {
    let datePicker = UIDatePicker()
    datePicker.datePickerMode = .date
    datePicker.setDimensions(height: height)
    
    return datePicker
}

//MARK: - DateFormatter
func formatTime(from time: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mma"
    let time = dateFormatter.string(from: time)
    return time
}

func formatDate(from date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E MMM d, Y"
    let date = dateFormatter.string(from: date)
    return date
}

func formatDateNoDay(from date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, Y"
    let date = dateFormatter.string(from: date)
    return date
}

func formatDateNoYear(from date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E, MMM d"
    let date = dateFormatter.string(from: date)
    return date
}

func formatDateNoTime(from date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E d"
    let date = dateFormatter.string(from: date)
    return date
}

func formatDateMonthDay(from date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d"
    let date = dateFormatter.string(from: date)
    return date
}

//MARK: - AddCourse
//Button that changes color of Cells
func makeColorButton(ofColor color: UIColor) -> UIButton {
    let button = UIButton()
    button.setDimensions(width: 40, height: 40)
    button.layer.cornerRadius = 20
    button.backgroundColor = color
    button.layer.borderColor = UIColor.lightGray.cgColor
    button.layer.borderWidth = 1
    
    return button
}

