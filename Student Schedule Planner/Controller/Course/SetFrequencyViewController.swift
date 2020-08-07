//
//  SetFrequencyViewController.swift
//  UniPlan
//
//  Created by Student on 2020-07-16.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit

/*
 * This VC allows the user to set reminders for all events
 * The user can choose to set the reminder for a specific date
 * Or a certain amount of time before the events starts
 */
class SetFrequencyViewController: FrequencyPickerViewController {
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        frequencyLabel.text = SingleClassService.shared.getRepeats()
        frequenyNum = TaskService.shared.getFrequencyNum()
        frequencyLength = TaskService.shared.getFrequencyLength()
    }
    //MARK: - properties
    //topView
    let topView = makeTopView(height: UIScreen.main.bounds.height/9)
    let titleLabel = makeTitleLabel(withText: "Set Frequency")
    let backButton = makeBackButton()
    
    //Not topView
    let frequencyPickerView = UIPickerView()
    let saveButton = makeSaveButton()
    
    let frequencyView = UIView()
    let frequencyLabel = makeHeading(withText: "Every Week")
    
    //MARK: - setup UI
    func setupViews() {
        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        view.addSubview(frequencyPickerView)
        view.addSubview(saveButton)
        view.addSubview(frequencyView)
        
        frequencyView.addSubview(frequencyLabel)
        
        //topView
        topView.addSubview(titleLabel)
        topView.addSubview(backButton)
        
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        titleLabel.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.centerX(in: topView)
        
        backButton.anchor(left: topView.leftAnchor, paddingLeft: 20)
        backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        frequencyView.anchor(top: topView.bottomAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20)
        frequencyView.setDimensions(width: UIScreen.main.bounds.width - 40, height: 50)
        frequencyView.layer.borderColor = UIColor.mainBlue.cgColor
        frequencyView.layer.cornerRadius = 10
        frequencyView.layer.borderWidth = 2
        frequencyLabel.anchor(left: frequencyView.leftAnchor, paddingLeft: 20)
        frequencyLabel.centerY(in: frequencyView)
        
        frequencyPickerView.anchor(top: frequencyView.bottomAnchor, left: frequencyView.leftAnchor)
        
        //Not topView
        setupTimeBeforePickerView()
        saveButton.centerX(in: view)
        saveButton.anchor(top: frequencyPickerView.bottomAnchor, paddingTop: 80)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        setupInitialSelectedRows()
    }
    
    func setupTimeBeforePickerView() {
        frequencyPickerView.delegate = self
        frequencyPickerView.dataSource = self
        frequencyPickerView.setDimensions(width: UIScreen.main.bounds.width - 140, height: 140)
        frequencyPickerView.centerX(in: view)
        frequencyPickerView.backgroundColor = .backgroundColor
    }
    
    func setupInitialSelectedRows() {
        frequencyPickerView.selectRow(TaskService.shared.getFrequencyNum()-1, inComponent:0, animated: false)
        frequencyPickerView.selectRow(TaskService.shared.getFrequencyLength(), inComponent:1, animated: false)
    }
    
    //MARK: - Actions
    @objc func backButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc func saveButtonPressed() {
        TaskService.shared.setFrequencyNum(frequency: frequenyNum)
        TaskService.shared.setFrequencyLenth(length: frequencyLength)
        SingleClassService.shared.setRepeats(num: frequenyNum, length: frequencyLength)
        dismiss(animated: true)
    }
    
    override func updateLabel() {
     var lengthString = ""
        switch frequencyLength{
        case 0:
            if frequenyNum == 1 {
                lengthString = "Week"
            } else {
                lengthString = "Weeks"
            }
        case 1:
            if frequenyNum == 1 {
                lengthString = "Day"
            } else {
                lengthString = "Days"
            }
        case 2:
            if frequenyNum == 1 {
                lengthString = "Weekday"
            } else {
                lengthString = "Weekdays"
            }
        default:
            break
        }
        frequencyLabel.text = frequenyNum == 1 ? "Every \(lengthString)" : "Every \(frequenyNum) \(lengthString)"
    }
    
}
