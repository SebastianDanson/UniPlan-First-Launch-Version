//
//  AddClassViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-14.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class AddClassViewController: UIViewController {
    
    let realm = try! Realm()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        SingleClassService.shared.setReminder(false)
        SingleClassService.shared.setRepeats(every: "Week")
        self.dismissKey()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        classTypeButton.setTitle(SingleClassService.shared.getType().description, for: .normal)
        reminderButton.setTitle(SingleClassService.shared.setupReminderString(), for: .normal)
        repeatsButton.setTitle(SingleClassService.shared.getRepeats(), for: .normal)
        SingleClassService.shared.setInitialLocation(location: locationTextField.text ?? "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reminderButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: reminderButton.frame.width-30, bottom: 0, right: 0)
        if SingleClassService.shared.getReminder() {
            reminderSwitch.isOn = true
            reminderSwitchToggled()
        }
    }
    
    //MARK: - Properties
    //topView
    let topView = makeTopView(height: UIScreen.main.bounds.height/9)
    let titleLabel = makeTitleLabel(withText: "Add Class")
    let backButton = makeBackButton()
    let deleteButton = makeDeleteButton()
    
    //Headings
    let reminderHeading = makeHeading(withText: "Reminder:")
    
    //Stack View
    let classDayStackView = makeStackView(withOrientation: .horizontal, spacing: 5)
    let stackView = makeStackView(withOrientation: .vertical, spacing: 3)
    
    //Class Day Circles
    let sunday = makeClassDaysCircleButton(withLetter: "S")
    let monday = makeClassDaysCircleButton(withLetter: "M")
    let tuesday = makeClassDaysCircleButton(withLetter: "T")
    let wednesday = makeClassDaysCircleButton(withLetter: "W")
    let thursday = makeClassDaysCircleButton(withLetter: "T")
    let friday = makeClassDaysCircleButton(withLetter: "F")
    let saturday = makeClassDaysCircleButton(withLetter: "S")
    
    //Others
    let locationTextField = makeTextField(withPlaceholder: "Location", height: 45)
    let saveButton = makeSaveButton()
    let classTypeButton = setValueButton(withPlaceholder: "Class", height: 50)
    let reminderButton = setValueButtonNoWidth(withPlaceholder: "When Class Starts")
    let reminderSwitch = UISwitch()
    let reminderView = makeAnimatedView()
    let startTimeView = PentagonView()
    let endTimeView = UIView()
    let timePickerView = makeTimePicker()
    let startTime = makeLabel(ofSize: 20, weight: .semibold)
    let endTime = makeLabel(ofSize: 20, weight: .semibold)
    let clockIcon = UIImage(systemName: "clock.fill")
    var clockImage = UIImageView(image: nil)
    let stackViewContainer = makeAnimatedView()
    let repeatsButton = setImageButton(withPlaceholder: "Every Week", imageName: "repeat")
    let nextIcon = UIImage(named: "nextMenuButtonGray")
    let hideReminderView = makeAnimatedView()
    
    //Spacers and sperators
    let spacerView1 = makeSpacerView(height: UIScreen.main.bounds.height/90)
    let spacerView2 = makeSpacerView(height: UIScreen.main.bounds.height/180)
    let spacerView3 = makeSpacerView(height: UIScreen.main.bounds.height/180)
    let spacerView4 = makeSpacerView(height: UIScreen.main.bounds.height/180)
    let spacerView5 = makeSpacerView(height: UIScreen.main.bounds.height/90)
    let spacerView6 = makeSpacerView(height: UIScreen.main.bounds.height/90)
    let seperatorView1 = makeSpacerView(height: 2)
    let seperatorView2 = makeSpacerView(height: 2)
    
    var stackViewContainerTopAnchorConstaint = NSLayoutConstraint()
    var stackViewContainerOtherAnchorConstaint = NSLayoutConstraint()
    
    //MARK: - setup UI
    func setupViews() {
        let nextImage = UIImageView(image: nextIcon!)
        clockImage = UIImageView(image: clockIcon!)
        
        seperatorView1.backgroundColor = .silver
        seperatorView2.backgroundColor = .silver
        
        view.backgroundColor = .backgroundColor
        
        view.addSubview(topView)
        view.addSubview(timePickerView)
        view.addSubview(classDayStackView)
        view.addSubview(stackViewContainer)
        view.addSubview(saveButton)
        view.addSubview(classTypeButton)
        view.addSubview(endTimeView)
        view.addSubview(startTimeView)
        view.addSubview(clockImage)
        view.addSubview(hideReminderView)
        
        repeatsButton.addSubview(nextImage)
        reminderView.addSubview(reminderSwitch)
        reminderView.addSubview(reminderHeading)
        
        startTimeView.addSubview(startTime)
        endTimeView.addSubview(endTime)
        
        topView.addSubview(titleLabel)
        topView.addSubview(backButton)
        topView.addSubview(deleteButton)
        
        stackViewContainer.addSubview(stackView)
        stackView.addArrangedSubview(spacerView1)
        stackView.addArrangedSubview(seperatorView1)
        stackView.addArrangedSubview(spacerView2)
        stackView.addArrangedSubview(repeatsButton)
        stackView.addArrangedSubview(spacerView3)
        stackView.addArrangedSubview(classDayStackView)
        stackView.addArrangedSubview(spacerView4)
        stackView.addArrangedSubview(seperatorView2)
        stackView.addArrangedSubview(spacerView5)
        stackView.addArrangedSubview(locationTextField)
        stackView.addArrangedSubview(spacerView6)
        stackView.addArrangedSubview(reminderView)
        stackView.addArrangedSubview(reminderButton)
        stackView.addSubview(hideReminderView)
        
        
        classDayStackView.addArrangedSubview(sunday)
        classDayStackView.addArrangedSubview(monday)
        classDayStackView.addArrangedSubview(tuesday)
        classDayStackView.addArrangedSubview(wednesday)
        classDayStackView.addArrangedSubview(thursday)
        classDayStackView.addArrangedSubview(friday)
        classDayStackView.addArrangedSubview(saturday)
        classDayStackView.distribution = .fillEqually
        
        //topView
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        titleLabel.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.centerX(in: topView)
        
        backButton.anchor(left: topView.leftAnchor, paddingLeft: 20)
        backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        deleteButton.anchor(right: topView.rightAnchor, paddingRight: 20)
        deleteButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        //deleteButton.addTarget(self, action: #selector(deleteTask), for: .touchUpInside)
        
        //Not topView
        classTypeButton.anchor(top: topView.bottomAnchor, paddingTop: UIScreen.main.bounds.height/50)
        classTypeButton.centerX(in: view)
        let startTap = UITapGestureRecognizer(target: self, action: #selector(startDateViewTapped))
        startTimeView.setDimensions(width: UIScreen.main.bounds.width/2,
                                    height: UIScreen.main.bounds.height/15)
        startTimeView.addGestureRecognizer(startTap)
        startTimeView.anchor(top: classTypeButton.bottomAnchor,
                             left: classTypeButton.leftAnchor,
                             paddingTop: UIScreen.main.bounds.height/50)
        
        clockImage.anchor(left: startTimeView.leftAnchor, paddingLeft: 25)
        clockImage.centerY(in: startTimeView)
        clockImage.tintColor = .darkGray
        
        let endTap = UITapGestureRecognizer(target: self, action: #selector(endDateViewTapped))
        endTimeView.addGestureRecognizer(endTap)
        endTimeView.layer.borderColor = UIColor.silver.cgColor
        endTimeView.layer.borderWidth = 1
        endTimeView.backgroundColor = .backgroundColor
        endTimeView.setDimensions(width: UIScreen.main.bounds.width/2,
                                  height: UIScreen.main.bounds.height/15)
        
        endTimeView.anchor(top: classTypeButton.bottomAnchor,
                           right: view.rightAnchor,
                           paddingTop: UIScreen.main.bounds.height/50,
                           paddingRight: 20)
        
        startTime.centerX(in: startTimeView)
        startTime.centerY(in: startTimeView)
        
        endTime.centerX(in: endTimeView)
        endTime.centerY(in: endTimeView)
        
        startTime.text = "\(formatTime(from: Date()))"
        endTime.text = "\(formatTime(from: Date().addingTimeInterval(3600)))"
        
        setupTimePickerView()
        
        stackViewContainer.anchor(bottom: view.bottomAnchor)
        stackViewContainer.centerX(in: view)
        
        stackView.centerX(in: stackViewContainer)
        stackView.setDimensions(width: UIScreen.main.bounds.width - 40)
        stackViewContainerTopAnchorConstaint = stackViewContainer.topAnchor.constraint(equalTo: startTimeView.bottomAnchor)
        stackViewContainerOtherAnchorConstaint = stackViewContainer.topAnchor.constraint(equalTo: timePickerView.bottomAnchor)
        stackViewContainerTopAnchorConstaint.isActive = true
        locationTextField.setIcon(UIImage(named: "location")!)
        
        nextImage.centerY(in: repeatsButton)
        nextImage.anchor(right: repeatsButton.rightAnchor, paddingRight: 10)
        
        reminderView.setDimensions(height: 30)
        reminderHeading.anchor(top: reminderView.topAnchor, left: reminderView.leftAnchor)
        reminderSwitch.centerYAnchor.constraint(equalTo: reminderHeading.centerYAnchor).isActive = true
        reminderSwitch.anchor(left: reminderHeading.rightAnchor, paddingLeft: 10)
        reminderSwitch.addTarget(self, action: #selector(reminderSwitchToggled), for: .touchUpInside)
        
        hideReminderView.anchor(top: reminderSwitch.bottomAnchor)
        hideReminderView.centerX(in: view)
        hideReminderView.setDimensions(height: 55)
        
        locationTextField.delegate = self
        
        classTypeButton.layer.borderWidth = 5
        classTypeButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        saveButton.centerX(in: view)
        saveButton.anchor(bottom: view.bottomAnchor, paddingBottom: 40)
        saveButton.addTarget(self, action: #selector(saveClass), for: .touchUpInside)
        
        //Setting button tags
        sunday.tag = 0
        monday.tag = 1
        tuesday.tag = 2
        wednesday.tag = 3
        thursday.tag = 4
        friday.tag = 5
        saturday.tag = 6
        
        //Adding targets to day buttons
        sunday.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        monday.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        tuesday.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        wednesday.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        thursday.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        friday.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        saturday.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        
        classTypeButton.addTarget(self, action: #selector(presentClassTypeAndRepeatsVC), for: .touchUpInside)
        repeatsButton.addTarget(self, action: #selector(presentClassTypeAndRepeatsVC), for: .touchUpInside)
        
        reminderButton.addTarget(self, action: #selector(reminderButtonPressed), for: .touchUpInside)
        
        if let classIndex = SingleClassService.shared.getClassIndex() {
            if let theClass = CourseService.shared.getClass(atIndex: classIndex) {
                SingleClassService.shared.setTypeAsString(classTypeString: theClass.type)
                SingleClassService.shared.setReminderTime([theClass.reminderTime[0],theClass.reminderTime[1]])
                
                SingleClassService.shared.setStartTime(time: theClass.startTime)
                SingleClassService.shared.setEndTime(time: theClass.endTime)
                
                startTime.text = formatTime(from: theClass.startTime)
                endTime.text = formatTime(from: theClass.endTime)
                
                for (index, day) in theClass.classDays.enumerated() {
                    if day == 1 {
                        switch index {
                        case 0:
                            sunday.highlight()
                        case 1:
                            monday.highlight()
                        case 2:
                            tuesday.highlight()
                        case 3:
                            wednesday.highlight()
                        case 4:
                            thursday.highlight()
                        case 5:
                            friday.highlight()
                        case 6:
                            saturday.highlight()
                        default:
                            break
                        }
                    }
                }
                
                locationTextField.text = theClass.location
                
                if theClass.reminder {
                    reminderButton.setTitle(SingleClassService.shared.setupReminderString(theClass: theClass), for: .normal)
                    SingleClassService.shared.setReminder(true)
                }
            }
        }
    }
    func setupTimePickerView() {
        timePickerView.anchor(top: startTimeView.bottomAnchor)
        timePickerView.centerX(in: view)
        timePickerView.setDimensions(width: UIScreen.main.bounds.width - 100)
        timePickerView.backgroundColor = .backgroundColor
        timePickerView.addTarget(self, action: #selector(timePickerDateChanged), for: .valueChanged)
    }
    
    //MARK: - Actions
    @objc func reminderSwitchToggled() {
        if reminderSwitch.isOn {
            SingleClassService.shared.setReminder(true)
            reminderButton.setTitle(SingleClassService.shared.setupReminderString(), for: .normal)
            //            TaskService.shared.setHideReminder(bool: false)
            TaskService.shared.askToSendNotifications()
            UIView.animate(withDuration: 0.3, animations: {
                self.hideReminderView.frame.origin.y = self.reminderButton.frame.maxY
            })
        } else {
            SingleClassService.shared.setReminder(false)
            //            TaskService.shared.setHideReminder(bool: true)
            UIView.animate(withDuration: 0.3, animations: {
                self.hideReminderView.frame.origin.y = self.hideReminderView.frame.origin.y-45
            })
        }
    }
    
    @objc func timePickerDateChanged() {
        stackViewContainerTopAnchorConstaint.isActive = false
        stackViewContainerOtherAnchorConstaint.isActive = true
        
        if startTimeView.color == UIColor.mainBlue {
            SingleClassService.shared.setStartTime(time: timePickerView.date)
            startTime.text = "\(formatTime(from: timePickerView.date))"
        } else {
            SingleClassService.shared.setEndTime(time: timePickerView.date)
            endTime.text  = "\(formatTime(from: timePickerView.date))"
        }
    }
    
    @objc func startDateViewTapped() {
        if startTimeView.color != UIColor.mainBlue {
            timePickerView.date = SingleClassService.shared.getStartTime()
            startTimeView.color = .mainBlue
            startTimeView.borderColor = .clear
            clockImage.tintColor = .white
            startTime.textColor = .backgroundColor
            endTime.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.stackViewContainer.frame.origin.y = self.timePickerView.frame.maxY
            })
        } else {
            startTimeView.color = .clouds
            startTimeView.borderColor = .silver
            clockImage.tintColor = .darkGray
            startTime.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.stackViewContainer.frame.origin.y = self.startTimeView.frame.maxY
            })
        }
        endTimeView.backgroundColor = .backgroundColor
        endTimeView.layer.borderColor = UIColor.silver.cgColor
    }
    
    @objc func endDateViewTapped() {
        
        if endTimeView.backgroundColor != UIColor.mainBlue {
            timePickerView.date = SingleClassService.shared.getEndTime()
            endTimeView.backgroundColor = .mainBlue
            endTimeView.layer.borderColor = UIColor.clear.cgColor
            endTime.textColor = .backgroundColor
            startTime.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.stackViewContainer.frame.origin.y = self.timePickerView.frame.maxY
            })
        } else {
            endTimeView.backgroundColor = .backgroundColor
            endTimeView.layer.borderColor = UIColor.silver.cgColor
            endTime.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.stackViewContainer.frame.origin.y = self.startTimeView.frame.maxY
            })
        }
        startTimeView.color = .clouds
        startTimeView.borderColor = .silver
        clockImage.tintColor = .darkGray
    }
    @objc func dayButtonTapped(button: UIButton) {
        stackViewContainerTopAnchorConstaint.isActive = true
        stackViewContainerOtherAnchorConstaint.isActive = false
        
        if SingleClassService.shared.getClassDays()[button.tag] == 0 {
            button.highlight()
        } else {
            button.unhighlight()
        }
        SingleClassService.shared.setClassDay(day: button.tag)
    }
    
    @objc func presentClassTypeAndRepeatsVC(button: UIButton) {
        if button == classTypeButton {
            SingleClassService.shared.setIsClassType(bool: true)
        } else {
            SingleClassService.shared.setIsClassType(bool: false)
        }
        let vc = ClassTypeAndRepeatsViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func repeatsButtonTapped(button: UIButton) {
        if SingleClassService.shared.getRepeats() != button.titleLabel?.text {
            button.highlight()
            SingleClassService.shared.setRepeats(every: button.titleLabel?.text ?? "Never")
            return
        }
        SingleClassService.shared.setRepeats(every: "Never")
    }
    
    @objc func reminderButtonPressed() {
        let vc = SetClassReminderViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func saveClass() {
        let theClass = SingleClass()
        theClass.classDays = configureClassDays()
        theClass.startTime = SingleClassService.shared.getStartTime()
        theClass.endTime = SingleClassService.shared.getEndTime()
        theClass.repeats = SingleClassService.shared.getRepeats()
        theClass.location = locationTextField.text ?? "Not Set"
        theClass.type = SingleClassService.shared.getType().description
        theClass.reminderTime[0] = SingleClassService.shared.getReminderTime()[0]
        theClass.reminderTime[1] = SingleClassService.shared.getReminderTime()[1]
        theClass.reminder = SingleClassService.shared.getReminder()
        TaskService.shared.setReminderTime([theClass.reminderTime[0], theClass.reminderTime[1]])
        
        do {
            try realm.write {
                if let classIndex = SingleClassService.shared.getClassIndex() {
                    var classToUpdate = CourseService.shared.getClass(atIndex: classIndex)
                    
                    for index in 0..<theClass.classDays.count{
                        classToUpdate?.classDays[index] = theClass.classDays[index]
                    }
                    classToUpdate?.startTime = theClass.startTime
                    classToUpdate?.endTime = theClass.endTime
                    classToUpdate?.repeats = theClass.repeats
                    classToUpdate?.location = theClass.location
                    classToUpdate?.type = theClass.type
                    classToUpdate?.reminderTime[0] = theClass.reminderTime[0]
                    classToUpdate?.reminderTime[1] = theClass.reminderTime[1]
                    classToUpdate?.reminder = theClass.reminder
                    TaskService.shared.updateTasks(forClass: theClass)
                } else {
                    realm.add(theClass, update: .modified)
                    var course = AllCoursesService.shared.getSelectedCourse()
                    course?.classes.append(theClass)
                    TaskService.shared.makeTasks(forClass: theClass)
                }
            }
        } catch {
            print("Error writing Class to realm \(error.localizedDescription)")
        }
        dismiss(animated: true)
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true)
    }
    
    //MARK: - Helper methods
    func configureClassDays() -> List<Int> {
        let days = List<Int>()
        days.append(objectsIn: SingleClassService.shared.getClassDays())
        return days
    }
}

//MARK: - TextField Delegate
extension AddClassViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
