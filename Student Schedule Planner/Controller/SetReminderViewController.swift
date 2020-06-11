//
//  SetReminderViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-08.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit

class SetReminderViewController: PickerViewController {
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: - properties
    //topView
    let topView = makeTopView(height: 90)
    let titleLabel = makeTitleLabel(withText: "Set Reminder")
    let backButton = makeBackButton()
    
    //Not topView
    let pickerTypeSegmentedControl = UISegmentedControl(items: ["Time Before", "Date"])
    let pickerTypeLabel = makeHeading(withText: "Time Before Task:")
    let timeBeforePickerView = UIPickerView()
    let datePickerView = makeDatePicker(height: 160)
    let saveButton = makeSaveButton()
    
    //MARK: - setup UI
    func setupViews() {
        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        view.addSubview(pickerTypeSegmentedControl)
        view.addSubview(timeBeforePickerView)
        view.addSubview(pickerTypeLabel)
        view.addSubview(datePickerView)
        view.addSubview(saveButton)
        
        //topView
        topView.addSubview(titleLabel)
        topView.addSubview(backButton)
        
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        titleLabel.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.centerX(in: topView)
        
        backButton.anchor(left: topView.leftAnchor, paddingLeft: 20)
        backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        //Not topView
        pickerTypeSegmentedControl.backgroundColor = .lightBlue
        pickerTypeSegmentedControl.selectedSegmentIndex = TaskService.shared.getDateOrTime()
        pickerTypeSegmentedControl.anchor(top: topView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 80, paddingRight: 80)
        pickerTypeSegmentedControl.addTarget(self, action: #selector(pickerTypeSCToggled), for: .valueChanged)
        
        pickerTypeLabel.anchor(top: pickerTypeSegmentedControl.bottomAnchor, left: view.leftAnchor, paddingTop: 40, paddingLeft: 20)
        setupTimeBeforePickerView()
        
        datePickerView.anchor(top: pickerTypeLabel.bottomAnchor, paddingTop: 10 )
        datePickerView.centerX(in: view)
        datePickerView.isHidden = true
        
        saveButton.centerX(in: view)
        saveButton.anchor(top: datePickerView.bottomAnchor, paddingTop: 80)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        
        setupInitialSelectedRows()
        pickerTypeSCToggled() //Sets initial pickerview
    }
    
    func setupTimeBeforePickerView() {
        timeBeforePickerView.delegate = self
        timeBeforePickerView.dataSource = self
        timeBeforePickerView.setDimensions(width: UIScreen.main.bounds.width - 140, height: 140)
        timeBeforePickerView.anchor(top: pickerTypeLabel.bottomAnchor)
        timeBeforePickerView.centerX(in: view)
        timeBeforePickerView.backgroundColor = .backgroundColor
    }
    
    func setupInitialSelectedRows() {
        hour = TaskService.shared.getReminderTime()[0]
        minutes = TaskService.shared.getReminderTime()[1]
        timeBeforePickerView.selectRow(hour, inComponent:0, animated: false)
        timeBeforePickerView.selectRow(minutes, inComponent:3, animated: false)
        
        datePickerView.setDate(TaskService.shared.getReminderDate(), animated: true)
    }
    
    //MARK: - Actions
    @objc func backButtonPressed() {
        dismiss(animated: true) 
    }
    
    @objc func saveButtonPressed() {
         let time = [self.hour, self.minutes]
         let date = datePickerView.date
         TaskService.shared.setReminderTime(time)
         TaskService.shared.setReminderDate(date: date)
         TaskService.shared.setDateOrTime(scIndex: pickerTypeSegmentedControl.selectedSegmentIndex)
         TaskService.shared.setHideReminder(bool: false)
         dismiss(animated: true)
     }
    
    @objc func pickerTypeSCToggled() {
        if pickerTypeSegmentedControl.selectedSegmentIndex == 0 {
            pickerTypeLabel.text = "Time Before Task:"
            timeBeforePickerView.isHidden = false
            datePickerView.isHidden = true
        } else {
            pickerTypeLabel.text = "Date Of Reminder:"
            timeBeforePickerView.isHidden = true
            datePickerView.isHidden = false
        }
    }
}
