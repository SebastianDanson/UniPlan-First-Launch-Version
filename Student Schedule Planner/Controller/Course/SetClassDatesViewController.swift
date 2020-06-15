//
//  SetClassDatesViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-15.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit

class SetClassDatesViewController: PickerViewController {
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: - properties
    //topView
    let topView = makeTopView(height: UIScreen.main.bounds.height/8)
    let titleLabel = makeTitleLabel(withText: "Set Class Dates")
    let backButton = makeBackButton()
    
    //Not topView
    let startTimeLabel = makeHeading(withText: "Start Date")
    let endTimeLabel = makeHeading(withText: "End Date")
    let startDatePickerView = makeDatePicker()
    let endDatePickerView = makeDatePicker()
    let saveButton = makeSaveButton()

    
    //MARK: - setup UI
    func setupViews() {
        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        view.addSubview(saveButton)
        view.addSubview(startTimeLabel)
        view.addSubview(endTimeLabel)
        view.addSubview(startDatePickerView)
        view.addSubview(endDatePickerView)
        
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
        startTimeLabel.anchor(top: topView.bottomAnchor, left: view.leftAnchor, paddingTop: 15, paddingLeft: 20)
        startDatePickerView.anchor(top: startTimeLabel.bottomAnchor)
        startDatePickerView.centerX(in: view)
        
        endTimeLabel.anchor(top: startDatePickerView.bottomAnchor, left: view.leftAnchor, paddingTop: 25, paddingLeft: 20)
        endDatePickerView.anchor(top: endTimeLabel.bottomAnchor)
        endDatePickerView.centerX(in: view)

        saveButton.anchor(top: endDatePickerView.bottomAnchor, paddingTop: UIScreen.main.bounds.height/14)
        saveButton.centerX(in: view)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
}
    
    //MARK: - Actions
    @objc func backButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc func saveButtonPressed() {
        SingleClassService.shared.setStartDate(date: startDatePickerView.date)
        SingleClassService.shared.setEndDate(date: endDatePickerView.date)
         dismiss(animated: true)
     }
}

