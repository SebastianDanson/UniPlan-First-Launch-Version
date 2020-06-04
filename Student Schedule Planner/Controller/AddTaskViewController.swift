//
//  AddTaskViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-02.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift

class AddTaskViewController: UIViewController {
    let realm = try! Realm()
    
    var hour:Int = 0
    var minutes:Int = 0
    var date: Date = Date()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: - Properties
    let topView = makeTopView(height: 90)
    let titleLabel = makeTitleLabel(withText: "Add Task")
    let backButton = makeBackButton()
    let titleHeading = makeHeading(withText: "Title")
    let startDatePicker = makeDatePicker()
    let titleTextField = makeTextField(withPlaceholder: "Title")
    let startDateHeading = makeHeading(withText: "Start Date")
    let durationHeading = makeHeading(withText: "Duration")
    let durationPickerView = UIPickerView()
    let saveButton = makeSaveButton()
    
    
    //MARK: - setup UI
    func setupViews() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(topView)
        view.addSubview(titleHeading)
        view.addSubview(titleTextField)
        view.addSubview(startDateHeading)
        view.addSubview(startDatePicker)
        view.addSubview(durationHeading)
        view.addSubview(saveButton)
        
        topView.addSubview(titleLabel)
        topView.addSubview(backButton)
        
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        titleLabel.anchor(top: topView.topAnchor, paddingTop: 40)
        titleLabel.centerX(in: topView)
        
        backButton.anchor(left: topView.leftAnchor, paddingLeft: 20)
        backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        
        titleHeading.anchor(top: topView.bottomAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20)
        titleTextField.centerX(in: view)
        titleTextField.anchor(top: titleHeading.bottomAnchor, paddingTop: 5)
        
        startDateHeading.anchor(top: titleTextField.bottomAnchor, left: view.leftAnchor, paddingTop: 40, paddingLeft: 20)
        startDatePicker.centerX(in: view)
        startDatePicker.anchor(top: startDateHeading.bottomAnchor, paddingTop: 5)
        
        durationHeading.anchor(top: startDatePicker.bottomAnchor, left: view.leftAnchor, paddingTop: 40, paddingLeft: 20)
        setUpDurationPickerView()
        
        saveButton.centerX(in: view)
        saveButton.anchor(top: durationPickerView.bottomAnchor, paddingTop: 80)
        saveButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
    }
    
    func setUpDurationPickerView() {
        view.addSubview(durationPickerView)
        durationPickerView.delegate = self
        durationPickerView.dataSource = self
        
        durationPickerView.anchor(top: durationHeading.bottomAnchor, paddingTop: 5)
        durationPickerView.centerX(in: view)
        durationPickerView.setDimensions(width: UIScreen.main.bounds.width-140, height: 150)
        durationPickerView.backgroundColor = .backgroundColor
    }
    
    //MARK: - Actions
    @objc func saveData() {
        
        if let title = titleTextField.text {
        
            let duration = hour*3600 + minutes * 60
            var endDate = startDatePicker.date
            endDate.addTimeInterval(TimeInterval(duration))
          
            let task = Task()
            task.title = title
            task.startDate = startDatePicker.date
            task.endDate = endDate
            
            do {
                try realm.write {
                    realm.add(task)
                }
            } catch {
                print("Error writing task to realm")
            }
            //let task = Task(title: title, startDate: startDatePicker.date, endDate: endDate)
            TaskService.shared.createTask(task: task)
            dismiss(animated: true)
        }
    }
}
//MARK: - Pickerview delegate and datasource
extension AddTaskViewController:UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 25
        case 1, 4:
            return 1
        case 3:
            return 60
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0:
            return pickerView.frame.size.width/6
        case 1:
            return pickerView.frame.size.width/4
        case 2:
            return pickerView.frame.size.width/8
        case 3:
            return pickerView.frame.size.width/6
        case 4:
            return pickerView.frame.size.width/4
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row)"
        case 1:
            return "hours"
        case 3:
            return "\(row)"
        case 4:
            return "min"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:
            hour = row
        case 3:
            minutes = row
        default:
            break;
        }
        
    }
}
