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
    
    //MARK: - setup UI
    func setupViews() {
        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        view.addSubview(pickerTypeSegmentedControl)
        view.addSubview(timeBeforePickerView)
        view.addSubview(pickerTypeLabel)
        view.addSubview(datePickerView)

        //topView
        topView.addSubview(titleLabel)
        topView.addSubview(backButton)
        
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        titleLabel.anchor(top: topView.topAnchor, paddingTop: 40)
        titleLabel.centerX(in: topView)
        
        backButton.anchor(left: topView.leftAnchor, paddingLeft: 20)
        backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        //Not topView
        pickerTypeSegmentedControl.backgroundColor = .lightBlue
        pickerTypeSegmentedControl.selectedSegmentIndex = 0
        pickerTypeSegmentedControl.anchor(top: topView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 80, paddingRight: 80)
        pickerTypeSegmentedControl.addTarget(self, action: #selector(pickerTypeSCToggled), for: .valueChanged)
        
        pickerTypeLabel.anchor(top: pickerTypeSegmentedControl.bottomAnchor, left: view.leftAnchor, paddingTop: 40, paddingLeft: 20)
        setupTimeBeforePickerView()
        
        datePickerView.anchor(top: pickerTypeLabel.bottomAnchor)
        datePickerView.centerX(in: view)
        datePickerView.isHidden = true
    }
    
    func setupTimeBeforePickerView() {
        timeBeforePickerView.delegate = self
        timeBeforePickerView.dataSource = self
        timeBeforePickerView.setDimensions(width: UIScreen.main.bounds.width - 40, height: 120)
        timeBeforePickerView.anchor(top: pickerTypeLabel.bottomAnchor, paddingTop: 15)
        timeBeforePickerView.centerX(in: view)
        timeBeforePickerView.backgroundColor = .backgroundColor
    }
    
    //MARK: - Actions
    @objc func backButtonPressed() {
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
