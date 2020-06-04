//
//  Factories.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-02.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit

//MARK: - Timeline View Controller
func makeTopView(height: CGFloat) -> UIView {
    let topView = UIView()
    topView.backgroundColor = .mainBlue
    let width = UIScreen.main.bounds.width
    topView.setDimensions(width: width, height: height)
    
    return topView
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

//MARK: - dateBox Functions
func makeDateLabel(withText text: String) -> UILabel{
    let label = UILabel()
    label.text = text
    label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    label.textColor = .mainBlue
    
    return label
}

func makeDateStackView() -> UIStackView {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fill
    stackView.alignment = .fill
    stackView.spacing = 7
    
    return stackView
}

//MARK: - addTask functions
func makeHeading(withText text: String) -> UILabel{
    let heading = UILabel()
    heading.text = text
    heading.textColor = .darkBlue
    heading.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    
    return heading
}

func makeDatePicker() -> UIDatePicker{
    let startDatePicker = UIDatePicker()
    startDatePicker.setDimensions(width: UIScreen.main.bounds.width - 40, height: 150)
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

//MARK: - Task Cell
func makeTaskLabel() -> UILabel {
       let taskLabel = UILabel()
       taskLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
       taskLabel.textColor = .darkBlue
       
       return taskLabel
   }
