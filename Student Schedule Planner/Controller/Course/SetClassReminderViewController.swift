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
    let titleLabel = makeTitleLabel(withText: "Set Reminder Before Each Class")
    let backButton = makeBackButton()
    
    //Not topView
    let timeBeforeLabel = makeHeading(withText: "Time Before Each Class:")
    let timeBeforePickerView = UIPickerView()
    let saveButton = makeSaveButton()
    
    //MARK: - setup UI
    func setupViews() {
        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        view.addSubview(timeBeforePickerView)
        view.addSubview(timeBeforeLabel)
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
        timeBeforeLabel.anchor(top: topView.bottomAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20)
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
        timeBeforePickerView.anchor(top: timeBeforeLabel.bottomAnchor)
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
         dismiss(animated: true)
     }
}
