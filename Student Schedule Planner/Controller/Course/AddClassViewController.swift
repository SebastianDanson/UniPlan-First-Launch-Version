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

/*
 * This VC allows the user to add, edit, or delete a class or routine
 */
class AddClassViewController: UIViewController {
    
    let realm = try! Realm()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        TaskService.shared.setDateOrTime(scIndex: 0)
        TaskService.shared.setReminderTime([0, 0])
        TaskService.shared.setReminderDate(date: Date())
        SingleClassService.shared.setReminder(false)
        SingleClassService.shared.setRepeats(every: "Week")
        SingleClassService.shared.resetDays()
        
        self.dismissKey()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        classTypeButton.setTitle(SingleClassService.shared.getType().description, for: .normal)
        reminderButton.setTitle(TaskService.shared.setupReminderString(), for: .normal)
        repeatsButton.setTitle("Every \(SingleClassService.shared.getRepeats())", for: .normal)
        colorRectangle.backgroundColor = TaskService.shared.getColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            reminderButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: reminderButton.frame.width-30, bottom: 0, right: 0)
            if SingleClassService.shared.getReminder(), !reminderSwitch.isOn {
                reminderSwitch.isOn = true
                reminderSwitchToggled()
            }
      
    }
    
    //MARK: - Properties
    //topView
    let topView = makeTopView(height: UIScreen.main.bounds.height/8.5)
    let titleLabel = makeTitleLabel(withText: "Add Class")
    let backButton = makeBackButton()
    let saveButton = makeSaveLabelButton()
    let saveLabelButton = makeSaveLabelButton()

    //Stack Views
    let classDayStackView = makeStackView(withOrientation: .horizontal, spacing: 5)
    let stackView = makeStackView(withOrientation: .vertical, spacing: 3)
    let stackViewContainer = makeAnimatedView()
    
    //Class Day Circles
    let sunday = makeClassDaysCircleButton(withLetter: "S")
    let monday = makeClassDaysCircleButton(withLetter: "M")
    let tuesday = makeClassDaysCircleButton(withLetter: "T")
    let wednesday = makeClassDaysCircleButton(withLetter: "W")
    let thursday = makeClassDaysCircleButton(withLetter: "T")
    let friday = makeClassDaysCircleButton(withLetter: "F")
    let saturday = makeClassDaysCircleButton(withLetter: "S")
    
    //Others
    let reminderHeading = makeHeading(withText: "Reminder:")
    
    let classTypeButton = setValueButton(withPlaceholder: "Class", height: 50)
    let repeatsButton = makeButtonWithImage(withPlaceholder: "Every Week", imageName: "repeat")
    let titleTextField = makeTextField(withPlaceholder: "Title", height: 50)
    
    let reminderButton = setValueButton(withPlaceholder: "When Class Starts", height: 45)
    let reminderSwitch = UISwitch()
    let reminderView = makeAnimatedView()
    let hideReminderView = makeAnimatedView()
    
    let locationView = makeAnimatedView()
    let locationTextField = makeTextField(withPlaceholder: "Location", height: 45)
    
    let startTimeView = PentagonView()
    let endTimeView = UIView()
    let startTime = makeLabel(ofSize: 20, weight: .semibold)
    let endTime = makeLabel(ofSize: 20, weight: .semibold)
    
    let startDateView = PentagonView()
    let endDateView = UIView()
    let startDate = makeLabel(ofSize: 20, weight: .semibold)
    let endDate = makeLabel(ofSize: 20, weight: .semibold)
    
    let timePicker = makeTimePicker(withHeight: UIScreen.main.bounds.height/6)
    let datePicker = makeDatePicker(withHeight: UIScreen.main.bounds.height/6)
    
    let clockIcon = UIImage(systemName: "clock.fill")
    var clockImage = UIImageView(image: nil)
    
    let nextIcon = UIImage(named: "nextMenuButtonGray")
    
    let calendarIcon = UIImage(systemName: "calendar")
    var calendarImage = UIImageView(image: nil)
    
    let colorHeading = makeHeading(withText: "Color:")
    let colorRectangle = UIView()
    
    //Spacers and sperators
    let spacerView1 = makeSpacerView(height: UIScreen.main.bounds.height/180)
    let spacerView2 = makeSpacerView(height: UIScreen.main.bounds.height/180)
    let spacerView3 = makeSpacerView(height: UIScreen.main.bounds.height/180)
    let spacerView4 = makeSpacerView(height: UIScreen.main.bounds.height/180)
    let spacerView5 = makeSpacerView(height: UIScreen.main.bounds.height/90)
    let spacerView6 = makeSpacerView(height: UIScreen.main.bounds.height/90)
    let seperatorView1 = makeSpacerView(height: 2)
    let seperatorView2 = makeSpacerView(height: 2)
    
    //Top Anchors for the stackViewContainer
    var stackViewContainerTopAnchorConstaint = NSLayoutConstraint()
    var stackViewContainerOtherAnchorConstaint = NSLayoutConstraint()
    
    //Top Anchors for the locationView
    var locationViewTopAnchorConstaint = NSLayoutConstraint()
    var locationViewOtherAnchorConstaint = NSLayoutConstraint()
    
    //MARK: - setup UI
    func setupViews() {
        if RoutineService.shared.getIsRoutine() {
            titleLabel.text = "Add Routine"
        }
        
        reminderButton.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 249), for: .horizontal)
        let nextImage = UIImageView(image: nextIcon!)
        
        clockImage = UIImageView(image: clockIcon!)
        calendarImage = UIImageView(image: calendarIcon!)
        
        seperatorView1.backgroundColor = .silver
        seperatorView2.backgroundColor = .silver
        
        view.backgroundColor = .backgroundColor
        
        view.addSubview(topView)
        view.addSubview(timePicker)
        view.addSubview(classDayStackView)
        view.addSubview(stackViewContainer)
        view.addSubview(classTypeButton)
        view.addSubview(titleTextField)
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
        locationView.addSubview(colorHeading)
        locationView.addSubview(colorRectangle)

        reminderView.addSubview(hideReminderView)
        
        startTimeView.addSubview(startTime)
        endTimeView.addSubview(endTime)
        
        startDateView.addSubview(startDate)
        startDateView.addSubview(calendarImage)
        endDateView.addSubview(endDate)
        
        topView.addSubview(titleLabel)
        topView.addSubview(backButton)
        topView.addSubview(saveButton)
        
        stackViewContainer.addSubview(stackView)
        stackViewContainer.addSubview(datePicker)
        stackViewContainer.addSubview(locationView)
        stackViewContainer.addSubview(endDateView)
        stackViewContainer.addSubview(startDateView)
        
        stackView.addArrangedSubview(locationTextField)
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
        
        saveButton.anchor(right: topView.rightAnchor, paddingRight: 25)
        saveButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        saveButton.addTarget(self, action: #selector(saveClass), for: .touchUpInside)
        
        //Not topView
        titleTextField.anchor(top: topView.bottomAnchor, paddingTop: UIScreen.main.bounds.height/50)
        titleTextField.centerX(in: view)
        titleTextField.font = UIFont.systemFont(ofSize: 24)
        titleTextField.layer.borderWidth = 4
        titleTextField.isHidden = true
        titleTextField.delegate = self
        
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
        calendarImage.anchor(left: startDateView.leftAnchor, paddingLeft: 10)
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
        
        startDate.centerXAnchor.constraint(equalTo: startDateView.centerXAnchor, constant: 5).isActive = true
        startDate.centerY(in: startDateView)
        
        endDate.centerXAnchor.constraint(equalTo: endDateView.centerXAnchor, constant: 12).isActive = true
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
        datePicker.minimumDate = Date()
        
        stackViewContainer.anchor(bottom: view.bottomAnchor)
        stackViewContainer.centerX(in: view)
        
        stackView.centerX(in: stackViewContainer)
        stackView.setDimensions(width: UIScreen.main.bounds.width - 40)
        stackViewContainerTopAnchorConstaint = stackViewContainer.topAnchor.constraint(equalTo: startTimeView.bottomAnchor)
        stackViewContainerOtherAnchorConstaint = stackViewContainer.topAnchor.constraint(equalTo: timePicker.bottomAnchor)
        stackViewContainerTopAnchorConstaint.isActive = true
        
        locationTextField.anchor(top: stackView.topAnchor, left: startTimeView.leftAnchor, paddingTop: 10)
        locationTextField.setIcon(UIImage(named: "location")!)
        
        nextImage.centerY(in: repeatsButton)
        nextImage.anchor(right: repeatsButton.rightAnchor, paddingRight: 10)
        
        locationView.backgroundColor = .backgroundColor
        locationView.anchor(left: startTimeView.leftAnchor)
        locationView.setDimensions(height: 200)
        locationViewTopAnchorConstaint = locationView.topAnchor.constraint(equalTo: startDateView.bottomAnchor)
        locationViewOtherAnchorConstaint = locationView.topAnchor.constraint(equalTo: datePicker.bottomAnchor)
        locationViewTopAnchorConstaint.isActive = true
        
        reminderHeading.anchor(top: colorRectangle.bottomAnchor, left: locationView.leftAnchor, paddingTop: 12)
        reminderSwitch.centerYAnchor.constraint(equalTo: reminderHeading.centerYAnchor).isActive = true
        reminderSwitch.anchor(left: reminderHeading.rightAnchor, paddingLeft: 10)
        reminderSwitch.addTarget(self, action: #selector(reminderSwitchToggled), for: .touchUpInside)
        
        reminderButton.anchor(top: reminderSwitch.bottomAnchor,
                              left: locationView.leftAnchor,
                              paddingTop: 5)
        
        colorHeading.anchor(top: locationView.topAnchor, left: locationView.leftAnchor, paddingTop: 10)
        colorRectangle.anchor(top: colorHeading.bottomAnchor,
                              left: locationView.leftAnchor,
                              right: locationView.rightAnchor,
                              paddingTop: 2)
        colorRectangle.backgroundColor = TaskService.shared.getColor()
        colorRectangle.setDimensions(height: UIScreen.main.bounds.height/19)
        colorRectangle.layer.cornerRadius = 5
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(colorRectanglePressed))
        colorRectangle.addGestureRecognizer(tap)

        
        reminderView.anchor(top: reminderSwitch.bottomAnchor)
        reminderView.centerX(in: view)
        
        hideReminderView.anchor(top: reminderView.topAnchor, paddingTop: 5)
        hideReminderView.centerX(in: view)
        hideReminderView.setDimensions(height: 55)
        
        locationTextField.delegate = self
        
        classTypeButton.layer.borderWidth = 5
        classTypeButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
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
        
        //If a class was selected
        if !RoutineService.shared.getIsRoutine() {
            if let classIndex = SingleClassService.shared.getClassIndex() {
                if let theClass = CourseService.shared.getClass(atIndex: classIndex) {
                    TaskService.shared.setReminderTime([theClass.reminderTime[0],theClass.reminderTime[1]])
                    
                    SingleClassService.shared.setStartTime(time: theClass.startTime)
                    SingleClassService.shared.setEndTime(time: theClass.endTime)
                    
                    startTime.text = formatTime(from: theClass.startTime)
                    endTime.text = formatTime(from: theClass.endTime)
                    
                    SingleClassService.shared.setStartDate(date: theClass.startDate)
                    SingleClassService.shared.setEndDate(date: theClass.endDate)
                    
                    startDate.text = formatDateNoDay(from: theClass.startDate)
                    endDate.text = formatDateNoDay(from: theClass.endDate)
                    
                    SingleClassService.shared.setTypeAsString(classTypeString: theClass.subType)
                    
                    SingleClassService.shared.setRepeats(every: theClass.repeats)
                    
                    //Highlights the days of the class
                    for (index, day) in theClass.classDays.enumerated() {
                        if day == 1 {
                            switch index {
                            case 0:
                                sunday.highlight()
                                SingleClassService.shared.setDay(day: 0)
                            case 1:
                                monday.highlight()
                                SingleClassService.shared.setDay(day: 1)
                            case 2:
                                tuesday.highlight()
                                SingleClassService.shared.setDay(day: 2)
                            case 3:
                                wednesday.highlight()
                                SingleClassService.shared.setDay(day: 3)
                            case 4:
                                thursday.highlight()
                                SingleClassService.shared.setDay(day: 4)
                            case 5:
                                friday.highlight()
                                SingleClassService.shared.setDay(day: 5)
                            case 6:
                                saturday.highlight()
                                SingleClassService.shared.setDay(day: 6)
                            default:
                                break
                            }
                        }
                    }
                    
                    locationTextField.text = theClass.location
                    
                    if theClass.reminder {
                        reminderButton.setTitle(TaskService.shared.setupReminderString(dateOrTime: 0, reminderTime: [theClass.reminderTime[0], theClass.reminderTime[1]], reminderDate: Date()), for: .normal)
                        SingleClassService.shared.setReminder(true)
                    }
                }
            }
        } else {
            classTypeButton.isHidden = true
            titleTextField.isHidden = false
            var dateComponent = DateComponents()
            dateComponent.month = 3
            let threeMonthsFromToday = Calendar.current.date(byAdding: dateComponent, to: Date())
            endDate.text = formatDateNoDay(from: threeMonthsFromToday ?? Date())
            SingleClassService.shared.setEndDate(date: threeMonthsFromToday ?? Date())
            
            if let routine = RoutineService.shared.getSelectedRoutine() {
                TaskService.shared.setReminderTime([routine.reminderTime[0],routine.reminderTime[1]])
                
                SingleClassService.shared.setStartTime(time: routine.startTime)
                SingleClassService.shared.setEndTime(time: routine.endTime)
                
                startTime.text = formatTime(from: routine.startTime)
                endTime.text = formatTime(from: routine.endTime)
                
                SingleClassService.shared.setStartDate(date: routine.startDate)
                SingleClassService.shared.setEndDate(date: routine.endDate)
                
                startDate.text = formatDateNoDay(from: routine.startDate)
                endDate.text = formatDateNoDay(from: routine.endDate)
                
                SingleClassService.shared.setRepeats(every: routine.repeats)
                titleTextField.text = routine.title
                
                //Highlights the days of the class
                for (index, day) in routine.days.enumerated() {
                    if day == 1 {
                        switch index {
                        case 0:
                            sunday.highlight()
                            SingleClassService.shared.setDay(day: 0)
                        case 1:
                            monday.highlight()
                            SingleClassService.shared.setDay(day: 1)
                        case 2:
                            tuesday.highlight()
                            SingleClassService.shared.setDay(day: 2)
                        case 3:
                            wednesday.highlight()
                            SingleClassService.shared.setDay(day: 3)
                        case 4:
                            thursday.highlight()
                            SingleClassService.shared.setDay(day: 4)
                        case 5:
                            friday.highlight()
                            SingleClassService.shared.setDay(day: 5)
                        case 6:
                            saturday.highlight()
                            SingleClassService.shared.setDay(day: 6)
                        default:
                            break
                        }
                    }
                }
                
                locationTextField.text = routine.location
                
                if routine.reminder {
                    reminderButton.setTitle(TaskService.shared.setupReminderString(dateOrTime: 0, reminderTime: [routine.reminderTime[0], routine.reminderTime[1]], reminderDate: Date()), for: .normal)
                    SingleClassService.shared.setReminder(true)
                }
            }
        }        
    }
    
    func setupTimePickerView() {
        timePicker.anchor(top: startTimeView.bottomAnchor)
        timePicker.centerX(in: view)
        timePicker.setDimensions(width: UIScreen.main.bounds.width - 100)
        timePicker.backgroundColor = .backgroundColor
        timePicker.addTarget(self, action: #selector(timePickerDateChanged), for: .valueChanged)
    }
    
    //MARK: - Actions
    @objc func colorRectanglePressed() {
        let vc = ColorsViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func reminderSwitchToggled() {
        if reminderSwitch.isOn {
            resetDateViews()
            resetTimeViews()
            SingleClassService.shared.setReminder(true)
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
            SingleClassService.shared.setStartTime(time: timePicker.date)
            startTime.text = "\(formatTime(from: timePicker.date))"
            
            if SingleClassService.shared.getStartTime() > SingleClassService.shared.getEndTime() {
                SingleClassService.shared.setEndTime(time: timePicker.date)
                endTime.text = "\(formatTime(from: timePicker.date))"
            }
        } else {
            SingleClassService.shared.setEndTime(time: timePicker.date)
            endTime.text  = "\(formatTime(from: timePicker.date))"
        }
    }
    
    @objc func datePickerDateChanged() {
        if startDateView.color == UIColor.mainBlue {
            SingleClassService.shared.setStartDate(date: datePicker.date)
            startDate.text = "\(formatDateNoDay(from: datePicker.date))"
            if SingleClassService.shared.getStartDate() > SingleClassService.shared.getEndDate() {
                SingleClassService.shared.setEndDate(date: datePicker.date)
                endDate.text = "\(formatDateNoDay(from: datePicker.date))"
            }
        } else {
            SingleClassService.shared.setEndDate(date: datePicker.date)
            endDate.text  = "\(formatDateNoDay(from: datePicker.date))"
        }
    }
    
    @objc func startTimeViewTapped() {
        resetDateViews()
        
        if startTimeView.color != UIColor.mainBlue {
            timePicker.date = SingleClassService.shared.getStartTime()
            startTimeView.color = .mainBlue
            startTimeView.borderColor = .clear
            clockImage.tintColor = .white
            startTime.textColor = .backgroundColor
            endTime.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.stackViewContainer.frame.origin.y = self.timePicker.frame.maxY
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
        locationTextField.resignFirstResponder()
        stackViewContainerTopAnchorConstaint.isActive = false
        stackViewContainerOtherAnchorConstaint.isActive = true
    }
    
    @objc func endTimeViewTapped() {
        resetDateViews()
        
        if endTimeView.backgroundColor != UIColor.mainBlue {
            timePicker.date = SingleClassService.shared.getEndTime()
            endTimeView.backgroundColor = .mainBlue
            endTimeView.layer.borderColor = UIColor.clear.cgColor
            endTime.textColor = .backgroundColor
            startTime.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.stackViewContainer.frame.origin.y = self.timePicker.frame.maxY
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
        locationTextField.resignFirstResponder()
        stackViewContainerTopAnchorConstaint.isActive = false
        stackViewContainerOtherAnchorConstaint.isActive = true
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
            datePicker.minimumDate = Date()
            locationViewTopAnchorConstaint.isActive = false
            locationViewOtherAnchorConstaint.isActive = true
        } else {
            startDateView.color = .clouds
            startDateView.borderColor = .silver
            calendarImage.tintColor = .darkBlue
            
            startDate.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.locationView.frame.origin.y = self.startDateView.frame.maxY
            })
            locationViewTopAnchorConstaint.isActive = true
            locationViewOtherAnchorConstaint.isActive = false
        }
        endDateView.backgroundColor = .backgroundColor
        endDateView.layer.borderColor = UIColor.silver.cgColor
        locationTextField.resignFirstResponder()
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
            locationViewTopAnchorConstaint.isActive = false
            locationViewOtherAnchorConstaint.isActive = true
            datePicker.minimumDate = SingleClassService.shared.getStartDate()
            
        } else {
            endDateView.backgroundColor = .backgroundColor
            endDateView.layer.borderColor = UIColor.silver.cgColor
            endDate.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.locationView.frame.origin.y = self.endDateView.frame.maxY
            })
            locationViewTopAnchorConstaint.isActive = true
            locationViewOtherAnchorConstaint.isActive = false
        }
        calendarImage.tintColor = .darkGray
        startDateView.color = .clouds
        startDateView.borderColor = .silver
        locationTextField.resignFirstResponder()
    }
    @objc func dayButtonTapped(button: UIButton) {
        if startTimeView.color == UIColor.mainBlue || endTimeView.backgroundColor == UIColor.mainBlue {
            stackViewContainerTopAnchorConstaint.isActive = false
            stackViewContainerOtherAnchorConstaint.isActive = true
        } else {
            stackViewContainerTopAnchorConstaint.isActive = true
            stackViewContainerOtherAnchorConstaint.isActive = false
        }
        
        if SingleClassService.shared.getDays()[button.tag] == 0 {
            button.highlight()
        } else {
            button.unhighlight()
        }
        SingleClassService.shared.setDay(day: button.tag)
    }
    
    @objc func presentClassTypeAndRepeatsVC(button: UIButton) {
        if button == classTypeButton {
            TaskService.shared.setIsClass(bool: true)
        } else {
            TaskService.shared.setIsClass(bool: false)
        }
        let vc = ClassTypeAndRepeatsViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func reminderButtonPressed() {
        TaskService.shared.setIsClass(bool: true)
        let vc = SetReminderViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func saveClass() {
        
        do {
            try realm.write {
                //If a previous class was selcted
                if !RoutineService.shared.getIsRoutine() {
                    let theClass = SingleClass()
                    theClass.classDays = configureDays()
                    theClass.startTime = SingleClassService.shared.getStartTime()
                    theClass.endTime = SingleClassService.shared.getEndTime()
                    theClass.repeats = SingleClassService.shared.getRepeats()
                    theClass.location = locationTextField.text ?? "Not Set"
                    theClass.type = "Class"
                    theClass.subType = SingleClassService.shared.getType().description
                    theClass.reminderTime[0] = TaskService.shared.getReminderTime()[0]
                    theClass.reminderTime[1] = TaskService.shared.getReminderTime()[1]
                    theClass.reminder = SingleClassService.shared.getReminder()
                    theClass.courseId = AllCoursesService.shared.getSelectedCourse()?.id ?? ""
                    theClass.startDate = SingleClassService.shared.getStartDate()
                    theClass.endDate = SingleClassService.shared.getEndDate()
                    TaskService.shared.setReminderTime([theClass.reminderTime[0], theClass.reminderTime[1]])
                    
                    if let classIndex = SingleClassService.shared.getClassIndex() {
                        let classToUpdate = CourseService.shared.getClass(atIndex: classIndex)
                        
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
                        let course = AllCoursesService.shared.getSelectedCourse()
                        course?.classes.append(theClass)
                        TaskService.shared.makeTasks(forClass: theClass)
                    }
                } else {
                    let routine = Routine()
                    routine.days = configureDays()
                    routine.startTime = SingleClassService.shared.getStartTime()
                    routine.endTime = SingleClassService.shared.getEndTime()
                    routine.repeats = SingleClassService.shared.getRepeats()
                    routine.location = locationTextField.text ?? "Not Set"
                    routine.reminderTime[0] = TaskService.shared.getReminderTime()[0]
                    routine.reminderTime[1] = TaskService.shared.getReminderTime()[1]
                    routine.reminder = SingleClassService.shared.getReminder()
                    routine.title = titleTextField.text ?? "Untitled"
                    routine.startDate = SingleClassService.shared.getStartDate()
                    routine.endDate = SingleClassService.shared.getEndDate()
                    
                    let rgb = TaskService.shared.getColor().components
                       
                    routine.color[0] = Double(rgb.red)
                    routine.color[1] = Double(rgb.green)
                    routine.color[2] = Double(rgb.blue)

                    TaskService.shared.setReminderTime([routine.reminderTime[0], routine.reminderTime[1]])
                    
                    if let routineToUpdate = RoutineService.shared.getSelectedRoutine() {
                        for index in 0..<routineToUpdate.days.count{
                            routineToUpdate.days[index] = routine.days[index]
                        }
                        routineToUpdate.startTime = routine.startTime
                        routineToUpdate.endTime = routine.endTime
                        routineToUpdate.repeats = routine.repeats
                        routineToUpdate.location = routine.location
                        routineToUpdate.reminderTime[0] = routine.reminderTime[0]
                        routineToUpdate.reminderTime[1] = routine.reminderTime[1]
                        routineToUpdate.reminder = routine.reminder
                        routineToUpdate.title = routine.title
                        routineToUpdate.startDate = routine.startDate
                        routineToUpdate.endDate = routine.endDate
                        routineToUpdate.color[0] = routine.color[0]
                        routineToUpdate.color[1] = routine.color[1]
                        routineToUpdate.color[2] = routine.color[2]

                        TaskService.shared.updateTasks(forRoutine: routineToUpdate)
                    } else {
                        realm.add(routine, update: .modified)
                        TaskService.shared.makeTasks(forRoutine: routine)
                    }
                }
            }
            
        } catch {
            print("Error writing Class to realm \(error.localizedDescription)")
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func deleteButtonPressed() {
        if let index = SingleClassService.shared.getClassIndex(){
            do{
                try realm.write{
                    //Deletes the class and all of the Tasks associated with that class
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
    func configureDays() -> List<Int> {
        let days = List<Int>()
        days.append(objectsIn: SingleClassService.shared.getDays())
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
            locationViewTopAnchorConstaint.isActive = true
            locationViewOtherAnchorConstaint.isActive = false
        }
    }
    
    func resetTimeViews() {
        if stackViewContainer.frame.origin.y == timePicker.frame.maxY {
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
            
            stackViewContainerTopAnchorConstaint.isActive = true
            stackViewContainerOtherAnchorConstaint.isActive = false
        }
    }
}

//MARK: - TextField Delegate
extension AddClassViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        resetDateViews()
        resetTimeViews()
    }
}
