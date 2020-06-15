//
//  SetClassTimeViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-15.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit

class SetClassTimeViewController: PickerViewController {
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: - properties
    //topView
    let topView = makeTopView(height: UIScreen.main.bounds.height/8)
    let titleLabel = makeTitleLabel(withText: "Set Class Time")
    let backButton = makeBackButton()
    
    //Not topView
    let startTimeLabel = makeHeading(withText: "Start Time")
    let endTimeLabel = makeHeading(withText: "End Time")
    let startTimePickerView = makeTimePicker()
    let endTimePickerView = makeTimePicker()
    let saveButton = makeSaveButton()

    
    //MARK: - setup UI
    func setupViews() {
        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        view.addSubview(saveButton)
        view.addSubview(startTimeLabel)
        view.addSubview(endTimeLabel)
        view.addSubview(startTimePickerView)
        view.addSubview(endTimePickerView)
        
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
        startTimePickerView.anchor(top: startTimeLabel.bottomAnchor)
        startTimePickerView.centerX(in: view)
        
        endTimeLabel.anchor(top: startTimePickerView.bottomAnchor, left: view.leftAnchor, paddingTop: 25, paddingLeft: 20)
        endTimePickerView.anchor(top: endTimeLabel.bottomAnchor)
        endTimePickerView.centerX(in: view)

        saveButton.anchor(top: endTimePickerView.bottomAnchor, paddingTop: UIScreen.main.bounds.height/14)
        saveButton.centerX(in: view)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
}
    
    //MARK: - Actions
    @objc func backButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc func saveButtonPressed() {
        SingleClassService.shared.setStartTime(time: startTimePickerView.date)
        SingleClassService.shared.setEndTime(time: endTimePickerView.date)
         dismiss(animated: true)
     }
}

