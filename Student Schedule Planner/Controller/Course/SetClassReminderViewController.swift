//
//  SetClassReminderViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-16.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit

class SetClassReminderViewController: PickerViewController {
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: - properties
    //topView
    let topView = makeTopView(height: UIScreen.main.bounds.height/8)
    let titleLabel = makeTitleLabel(withText: "Set Reminder")
    let backButton = makeBackButton()
      
    //Not topView
    let timeBeforeHeading = makeHeading(withText: "Time Before Each Class:")
    let remindMeHeading = makeHeading(withText: "Remind Me:")
    let reminderSwitch = UISwitch()
    let timeBeforePickerView = UIPickerView()
    let saveButton = makeSaveButton()
    
    //MARK: - setup UI
    func setupViews() {
        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        view.addSubview(timeBeforePickerView)
        view.addSubview(timeBeforeHeading)
        view.addSubview(saveButton)
        view.addSubview(remindMeHeading)
        view.addSubview(reminderSwitch)
        
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
        remindMeHeading.anchor(top: topView.bottomAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20)
        reminderSwitch.anchor(left: remindMeHeading.rightAnchor, bottom: remindMeHeading.bottomAnchor, paddingLeft: 10)
        reminderSwitch.isOn = true
        reminderSwitch.addTarget(self, action: #selector(reminderSwitchToggled), for: .touchUpInside)
        
        timeBeforeHeading.anchor(top: remindMeHeading.bottomAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20)
        setupTimeBeforePickerView()
        
        saveButton.centerX(in: view)
        saveButton.anchor(top: timeBeforePickerView.bottomAnchor, paddingTop: UIScreen.main.bounds.height/11)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
                
        setupInitialSelectedRows()
    }
    
    func setupTimeBeforePickerView() {
        timeBeforePickerView.delegate = self
        timeBeforePickerView.dataSource = self
        timeBeforePickerView.setDimensions(width: UIScreen.main.bounds.width - 140, height: 140)
        timeBeforePickerView.anchor(top: timeBeforeHeading.bottomAnchor)
        timeBeforePickerView.centerX(in: view)
        timeBeforePickerView.backgroundColor = .backgroundColor
    }
    
    func setupInitialSelectedRows() {
        hour = TaskService.shared.getReminderTime()[0]
        minutes = TaskService.shared.getReminderTime()[1]
        timeBeforePickerView.selectRow(hour, inComponent:0, animated: false)
        timeBeforePickerView.selectRow(minutes, inComponent:3, animated: false)
    }
    
    //MARK: - Actions
    @objc func backButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc func saveButtonPressed() {
         let time = [self.hour, self.minutes]
        
        SingleClassService.shared.setReminderTime(time)
        SingleClassService.shared.setReminder(reminderSwitch.isOn)
        
        dismiss(animated: true)
     }
    
    @objc func reminderSwitchToggled() {
        if reminderSwitch.isOn {
            timeBeforePickerView.isHidden = false
            timeBeforeHeading.isHidden = false
        } else {
            timeBeforePickerView.isHidden = true
            timeBeforeHeading.isHidden = true
        }
    }
}
