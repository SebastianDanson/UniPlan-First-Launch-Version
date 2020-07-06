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
        SingleClassService.shared.resetClassDays()
        
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
            //reminderSwitchToggled()
        }
    }
    
    //MARK: - Properties
    //topView
    let topView = makeTopView(height: UIScreen.main.bounds.height/8.5)
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
    let locationView = makeAnimatedView()
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
    let startDateView = PentagonView()
    let endDateView = UIView()
    let startDate = makeLabel(ofSize: 20, weight: .semibold)
    let endDate = makeLabel(ofSize: 20, weight: .semibold)
    let datePicker = makeDatePicker()
    let calendarIcon = UIImage(systemName: "calendar")
    var calendarImage = UIImageView(image: nil)
    
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
        calendarImage = UIImageView(image: calendarIcon!)
        
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
        locationView.addSubview(locationTextField)
        locationView.addSubview(reminderSwitch)
        locationView.addSubview(reminderHeading)
        locationView.addSubview(reminderButton)
        locationView.addSubview(reminderView)
        reminderView.addSubview(hideReminderView)
        
        startTimeView.addSubview(startTime)
        endTimeView.addSubview(endTime)
        
        startDateView.addSubview(startDate)
        startDateView.addSubview(calendarImage)
        endDateView.addSubview(endDate)
        
        topView.addSubview(titleLabel)
        topView.addSubview(backButton)
        topView.addSubview(deleteButton)
        
        stackViewContainer.addSubview(stackView)
        stackViewContainer.addSubview(datePicker)
        stackViewContainer.addSubview(locationView)
        stackViewContainer.addSubview(endDateView)
        stackViewContainer.addSubview(startDateView)
        
        stackView.addArrangedSubview(spacerView1)
        stackView.addArrangedSubview(seperatorView1)
        stackView.addArrangedSubview(spacerView2)
        stackView.addArrangedSubview(repeatsButton)
        stackView.addArrangedSubview(spacerView3)
        stackView.addArrangedSubview(classDayStackView)
        stackView.addArrangedSubview(spacerView4)
        stackView.addArrangedSubview(seperatorView2)
        stackView.addArrangedSubview(spacerView5)
        
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
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        
        //Not topView
        classTypeButton.anchor(top: topView.bottomAnchor, paddingTop: UIScreen.main.bounds.height/50)
        classTypeButton.centerX(in: view)
        let startTap = UITapGestureRecognizer(target: self, action: #selector(startTimeViewTapped))
        startTimeView.setDimensions(width: UIScreen.main.bounds.width/2,
                                    height: UIScreen.main.bounds.height/15)
        startTimeView.addGestureRecognizer(startTap)
        startTimeView.anchor(top: classTypeButton.bottomAnchor,
                             left: classTypeButton.leftAnchor,
                             paddingTop: UIScreen.main.bounds.height/50)
        
        clockImage.anchor(left: startTimeView.leftAnchor, paddingLeft: 18)
        clockImage.centerY(in: startTimeView)
        clockImage.tintColor = .darkGray
        
        let endTap = UITapGestureRecognizer(target: self, action: #selector(endTimeViewTapped))
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
        SingleClassService.shared.setStartTime(time: Date())
        SingleClassService.shared.setEndTime(time: Date().addingTimeInterval(3600))
        
        let startDateTap = UITapGestureRecognizer(target: self, action: #selector(startDateViewTapped))
        startDateView.setDimensions(width: UIScreen.main.bounds.width/2,
                                    height: UIScreen.main.bounds.height/15)
        startDateView.addGestureRecognizer(startDateTap)
        startDateView.anchor(top: spacerView5.bottomAnchor,
                             left: classTypeButton.leftAnchor,
                             paddingTop: 0)
        calendarImage.anchor(left: startDateView.leftAnchor, paddingLeft: 18)
        calendarImage.centerY(in: startDateView)
        calendarImage.tintColor = .darkGray
        
        let endDateTap = UITapGestureRecognizer(target: self, action: #selector(endDateViewTapped))
        endDateView.addGestureRecognizer(endDateTap)
        endDateView.layer.borderColor = UIColor.silver.cgColor
        endDateView.layer.borderWidth = 1
        endDateView.backgroundColor = .backgroundColor
        endDateView.setDimensions(width: UIScreen.main.bounds.width/2,
                                  height: UIScreen.main.bounds.height/15)
        
        endDateView.anchor(top: spacerView5.bottomAnchor,
                           right: view.rightAnchor,
                           paddingTop: 0,
                           paddingRight: 20)
        
        startDate.centerX(in: startDateView)
        startDate.centerY(in: startDateView)
        
        endDate.centerX(in: endDateView)
        endDate.centerY(in: endDateView)
        
        let course = AllCoursesService.shared.getSelectedCourse()
        startDate.text = "\(formatDateNoDay(from: Date()))"
        endDate.text = "\(formatDateNoDay(from: course?.endDate ?? Date()))"
        SingleClassService.shared.setStartDate(date: Date())
        SingleClassService.shared.setEndDate(date: course?.endDate ?? Date())

        setupTimePickerView()
        
        datePicker.anchor(top: startDateView.bottomAnchor)
        datePicker.centerX(in: view)
        datePicker.addTarget(self, action: #selector(datePickerDateChanged), for: .valueChanged)
        
        stackViewContainer.anchor(bottom: view.bottomAnchor)
        stackViewContainer.centerX(in: view)
        
        stackView.centerX(in: stackViewContainer)
        stackView.setDimensions(width: UIScreen.main.bounds.width - 40)
        stackViewContainerTopAnchorConstaint = stackViewContainer.topAnchor.constraint(equalTo: startTimeView.bottomAnchor)
        stackViewContainerOtherAnchorConstaint = stackViewContainer.topAnchor.constraint(equalTo: timePickerView.bottomAnchor)
        stackViewContainerTopAnchorConstaint.isActive = true
        
        locationTextField.anchor(top: locationView.topAnchor, left: startTimeView.leftAnchor, paddingTop: 10)
        locationTextField.setIcon(UIImage(named: "location")!)
        
        nextImage.centerY(in: repeatsButton)
        nextImage.anchor(right: repeatsButton.rightAnchor, paddingRight: 10)
        
        locationView.backgroundColor = .backgroundColor
        locationView.anchor(top: startDateView.bottomAnchor, left: startTimeView.leftAnchor)
        locationView.setDimensions(height: 200)
        reminderHeading.anchor(top: locationTextField.bottomAnchor, left: locationView.leftAnchor, paddingTop: 10)
        reminderSwitch.centerYAnchor.constraint(equalTo: reminderHeading.centerYAnchor).isActive = true
        reminderSwitch.anchor(left: reminderHeading.rightAnchor, paddingLeft: 10)
        reminderSwitch.addTarget(self, action: #selector(reminderSwitchToggled), for: .touchUpInside)
        
        reminderButton.anchor(top: reminderSwitch.bottomAnchor, left: locationView.leftAnchor, right: locationView.rightAnchor, paddingTop: 5)
        
        reminderView.anchor(top: reminderSwitch.bottomAnchor)
        reminderView.centerX(in: view)

        hideReminderView.anchor(top: reminderView.topAnchor, paddingTop: 5)
        hideReminderView.centerX(in: view)
        hideReminderView.setDimensions(height: 55)
        
        locationTextField.delegate = self
        
        classTypeButton.layer.borderWidth = 5
        classTypeButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        saveButton.centerX(in: view)
        saveButton.anchor(bottom: view.bottomAnchor, paddingBottom: UIScreen.main.bounds.height/25)
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
                SingleClassService.shared.setReminderTime([theClass.reminderTime[0],theClass.reminderTime[1]])
                
                SingleClassService.shared.setStartTime(time: theClass.startTime)
                SingleClassService.shared.setEndTime(time: theClass.endTime)
                
                startTime.text = formatTime(from: theClass.startTime)
                endTime.text = formatTime(from: theClass.endTime)
                
                SingleClassService.shared.setStartDate(date: theClass.startDate)
                SingleClassService.shared.setEndDate(date: theClass.endDate)
                
                startDate.text = formatDateNoDay(from: theClass.startDate)
                endDate.text = formatDateNoDay(from: theClass.endDate)
                
                SingleClassService.shared.setTypeAsString(classTypeString: theClass.subType)
                classTypeButton.setTitle(theClass.subType, for: .normal)
                
                for (index, day) in theClass.classDays.enumerated() {
                    if day == 1 {
                        switch index {
                        case 0:
                            sunday.highlight()
                            SingleClassService.shared.setClassDay(day: 0)
                        case 1:
                            monday.highlight()
                            SingleClassService.shared.setClassDay(day: 1)
                        case 2:
                            tuesday.highlight()
                            SingleClassService.shared.setClassDay(day: 2)
                        case 3:
                            wednesday.highlight()
                            SingleClassService.shared.setClassDay(day: 3)
                        case 4:
                            thursday.highlight()
                            SingleClassService.shared.setClassDay(day: 4)
                        case 5:
                            friday.highlight()
                            SingleClassService.shared.setClassDay(day: 5)
                        case 6:
                            saturday.highlight()
                            SingleClassService.shared.setClassDay(day: 6)
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
            TaskService.shared.askToSendNotifications()
            UIView.animate(withDuration: 0.3, animations: {
                self.hideReminderView.frame.origin.y = self.hideReminderView.frame.origin.y + 45
            })
        } else {
            SingleClassService.shared.setReminder(false)
            UIView.animate(withDuration: 0.3, animations: {
                self.hideReminderView.frame.origin.y = self.hideReminderView.frame.origin.y - 45
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
    
    @objc func datePickerDateChanged() {
        
        if startDateView.color == UIColor.mainBlue {
            SingleClassService.shared.setStartDate(date: datePicker.date)
            startDate.text = "\(formatDateNoDay(from: datePicker.date))"
        } else {
            SingleClassService.shared.setEndDate(date: datePicker.date)
            endDate.text  = "\(formatDateNoDay(from: datePicker.date))"
        }
    }
    
    @objc func startTimeViewTapped() {
       resetDateViews()
        
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
    
    @objc func endTimeViewTapped() {
        resetDateViews()
        
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
    
    @objc func startDateViewTapped() {
        resetTimeViews()
        if startDateView.color != UIColor.mainBlue {
            datePicker.date = SingleClassService.shared.getStartDate()
            startDateView.color = .mainBlue
            startDateView.borderColor = .clear
            calendarImage.tintColor = .white
            startDate.textColor = .backgroundColor
            endDate.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.locationView.frame.origin.y = self.datePicker.frame.maxY
            })
        } else {
            startDateView.color = .clouds
            startDateView.borderColor = .silver
            calendarImage.tintColor = .darkBlue
            
            startDate.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.locationView.frame.origin.y = self.startDateView.frame.maxY
            })
        }
        endDateView.backgroundColor = .backgroundColor
        endDateView.layer.borderColor = UIColor.silver.cgColor
    }
    
    @objc func endDateViewTapped() {
        resetTimeViews()
        if endDateView.backgroundColor != UIColor.mainBlue {
            datePicker.date = SingleClassService.shared.getEndDate()
            endDateView.backgroundColor = .mainBlue
            endDateView.layer.borderColor = UIColor.clear.cgColor
            endDate.textColor = .backgroundColor
            startDate.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.locationView.frame.origin.y = self.datePicker.frame.maxY
            })
        } else {
            endDateView.backgroundColor = .backgroundColor
            endDateView.layer.borderColor = UIColor.silver.cgColor
            endDate.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.locationView.frame.origin.y = self.endDateView.frame.maxY
            })
        }
        calendarImage.tintColor = .darkGray
        startDateView.color = .clouds
        startDateView.borderColor = .silver
    }
    @objc func dayButtonTapped(button: UIButton) {
        if startTimeView.color == UIColor.mainBlue || endTimeView.backgroundColor == UIColor.mainBlue {
            stackViewContainerTopAnchorConstaint.isActive = false
            stackViewContainerOtherAnchorConstaint.isActive = true
        } else {
            stackViewContainerTopAnchorConstaint.isActive = true
            stackViewContainerOtherAnchorConstaint.isActive = false
        }
        
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
        theClass.type = "Class"
        theClass.subType = SingleClassService.shared.getType().description
        theClass.reminderTime[0] = SingleClassService.shared.getReminderTime()[0]
        theClass.reminderTime[1] = SingleClassService.shared.getReminderTime()[1]
        theClass.reminder = SingleClassService.shared.getReminder()
        theClass.course = AllCoursesService.shared.getSelectedCourse()?.title ?? ""
        theClass.startDate = SingleClassService.shared.getStartDate()
        theClass.endDate = SingleClassService.shared.getEndDate()
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
                    classToUpdate?.startDate = theClass.startDate
                    classToUpdate?.endDate = theClass.endDate
                    classToUpdate?.repeats = theClass.repeats
                    classToUpdate?.location = theClass.location
                    classToUpdate?.type = theClass.type
                    classToUpdate?.reminderTime[0] = theClass.reminderTime[0]
                    classToUpdate?.reminderTime[1] = theClass.reminderTime[1]
                    classToUpdate?.reminder = theClass.reminder
                    classToUpdate?.subType = theClass.subType

                    if let theClassToUpdate = classToUpdate {
                        TaskService.shared.updateTasks(forClass: theClassToUpdate)
                    }
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
        backButtonPressed()
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: {
            [0, 0, 0, 0, 0, 0, 0]
        })
    }
    
    @objc func deleteButtonPressed() {
        if let index = SingleClassService.shared.getClassIndex(){
            do{
                try realm.write{
                    if let classToDelete = CourseService.shared.getClass(atIndex: index) {
                        TaskService.shared.deleteTasks(forClass: classToDelete)
                        realm.delete(classToDelete)
                        CourseService.shared.updateClasses()
                    }
                }
            } catch{
                print("error deleting class and class tasks \(error.localizedDescription)")
            }
        }
        backButtonPressed()
    }
    //MARK: - Helper methods
    func configureClassDays() -> List<Int> {
        let days = List<Int>()
        days.append(objectsIn: SingleClassService.shared.getClassDays())
        return days
    }
    
    func resetDateViews() {
        if locationView.frame.origin.y == datePicker.frame.maxY {
            UIView.animate(withDuration: 0.3, animations: {
                self.locationView.frame.origin.y = self.startDateView.frame.maxY
            })
            
            startDateView.color = .clouds
            endDateView.backgroundColor = .backgroundColor
            startDate.textColor = .darkBlue
            endDate.textColor = .darkBlue
            calendarImage.tintColor = .darkGray
            endDateView.layer.borderColor = UIColor.silver.cgColor
            startDateView.borderColor = .silver
        }
    }
    
    func resetTimeViews() {
        if stackViewContainer.frame.origin.y == timePickerView.frame.maxY {
            UIView.animate(withDuration: 0.3, animations: {
                self.stackViewContainer.frame.origin.y = self.startTimeView.frame.maxY
            })
            
            startTimeView.color = .clouds
            endTimeView.backgroundColor = .backgroundColor
            startTime.textColor = .darkBlue
            endTime.textColor = .darkBlue
            clockImage.tintColor = .darkGray
            endTimeView.layer.borderColor = UIColor.silver.cgColor
            startTimeView.borderColor = .silver
        }
    }
}

//MARK: - TextField Delegate
extension AddClassViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
