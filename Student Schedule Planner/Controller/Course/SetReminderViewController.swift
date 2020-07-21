//
//  SetReminderViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-08.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit

/*
 * This VC allows the user to set reminders for all events
 * The user can choose to set the reminder for a specific date
 * Or a certain amount of time before the events starts
 */
class SetReminderViewController: PickerViewController {
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        TaskService.shared.setIsClass(bool: false)
    }
    
    //MARK: - properties
    //topView
    let topView = makeTopView(height: UIScreen.main.bounds.height/9)
    let titleLabel = makeTitleLabel(withText: "Set Reminder")
    let backButton = makeBackButton()
    
    //Not topView
    let pickerTypeSegmentedControl = UISegmentedControl(items: ["Time Before", "Date"])
    let pickerTypeLabel = makeHeading(withText: "Time Before:")
    let timeBeforePickerView = UIPickerView()
    let datePickerView = makeDateAndTimePicker(height: 160)
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
        pickerTypeSegmentedControl.isHidden = false
        pickerTypeSegmentedControl.backgroundColor = .mainBlue
        pickerTypeSegmentedControl.selectedSegmentIndex = TaskService.shared.getDateOrTime()
        pickerTypeSegmentedControl.anchor(top: topView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 80, paddingRight: 80)
        pickerTypeSegmentedControl.addTarget(self, action: #selector(pickerTypeSCToggled), for: .valueChanged)
        pickerTypeSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkBlue, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)], for: .selected)
        pickerTypeSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.backgroundColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)], for: .normal)
        
        setupTimeBeforePickerView()
        
        datePickerView.anchor(top: pickerTypeLabel.bottomAnchor, paddingTop: 10 )
        datePickerView.centerX(in: view)
        datePickerView.isHidden = true
        
        saveButton.centerX(in: view)
        saveButton.anchor(top: datePickerView.bottomAnchor, paddingTop: 80)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        
        setupInitialSelectedRows()
        pickerTypeSCToggled() //Sets initial pickerview
        
        //If the user is setting reminders for a class the SC is hidden, so the user can only choose the time before option
        if TaskService.shared.getIsClass() {
            pickerTypeSegmentedControl.selectedSegmentIndex = 0
            pickerTypeSegmentedControl.isHidden = true
            timeBeforePickerView.isHidden = false
            datePickerView.isHidden = true
            pickerTypeLabel.text = "Time Before"
            pickerTypeLabel.anchor(top: topView.bottomAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20)
        } else {
            pickerTypeLabel.anchor(top: pickerTypeSegmentedControl.bottomAnchor, left: view.leftAnchor, paddingTop: 40, paddingLeft: 20)
        }
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
        
        if TaskService.shared.getReminderDate() < Date() {
            datePickerView.date = Date()
        } else {
            datePickerView.date = TaskService.shared.getReminderDate()
        }
    }
    
    //MARK: - Actions
    @objc func backButtonPressed() {
        TaskService.shared.setIsClass(bool: false)
        dismiss(animated: true)
    }
    
    @objc func saveButtonPressed() {
        let time = [self.hour, self.minutes]
        let date = datePickerView.date
        TaskService.shared.setReminderTime(time)
        TaskService.shared.setReminderDate(date: date)
        TaskService.shared.setDateOrTime(scIndex: pickerTypeSegmentedControl.selectedSegmentIndex)
        TaskService.shared.setHideReminder(bool: false)
        SingleClassService.shared.setReminder(true)
        
        dismiss(animated: true)
    }
    
    @objc func pickerTypeSCToggled() {
        if pickerTypeSegmentedControl.selectedSegmentIndex == 0 {
            pickerTypeLabel.text = "Time Before:"
            timeBeforePickerView.isHidden = false
            datePickerView.isHidden = true
        } else {
            pickerTypeLabel.text = "Date Of Reminder:"
            timeBeforePickerView.isHidden = true
            datePickerView.isHidden = false
        }
    }
}
