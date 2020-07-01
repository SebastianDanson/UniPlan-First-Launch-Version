//
//  AddCourseViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-18.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit

class AddCourseViewController: PickerViewController {
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKey()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CourseService.shared.setColor(int: 0)
    }
    
    //MARK: - properties
    //topView
    let topView = makeTopView(height: UIScreen.main.bounds.height/8.5)
    let titleLabel = makeTitleLabel(withText: "Add Course")
    let backButton = makeBackButton()
    
    //Not topView
    let titleTextField = makeTextField(withPlaceholder: "Course Name:", height: 50 )
    let startDateView = PentagonView()
    let endDateView = UIView()
    let datePickerView = makeDatePicker()
    let startDate = makeLabel(ofSize: 20, weight: .semibold)
    let endDate = makeLabel(ofSize: 20, weight: .semibold)
    let colorHeading = makeHeading(withText: "Color:")
    let colorStackView = makeStackView(withOrientation: .horizontal, spacing: 3)
    let saveButton = makeSaveButton()
    let colorView = makeAnimatedView()
    let calendarIcon = UIImage(systemName: "calendar")
    var calendarImage = UIImageView(image: nil)
    
    var colorTopAnchorConstaint = NSLayoutConstraint()
    var colorOtherAnchorConstaint = NSLayoutConstraint()
    
    //Color Buttons
    let red = makeColorButton(ofColor: .alizarin)
    let orange = makeColorButton(ofColor: .carrot)
    let yellow = makeColorButton(ofColor: .sunflower)
    let green = makeColorButton(ofColor: .emerald)
    let turquoise = makeColorButton(ofColor: .turquoise)
    let blue = makeColorButton(ofColor: .riverBlue)
    let darkBlue = makeColorButton(ofColor: .midnightBlue)
    let purple = makeColorButton(ofColor: .amethyst)
    
    //MARK: - UISetup
    func setupViews() {
        calendarImage = UIImageView(image: calendarIcon!)
        
        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        view.addSubview(titleTextField)
        view.addSubview(datePickerView)
        view.addSubview(colorView)
        view.addSubview(endDateView)
        view.addSubview(startDateView)
        view.addSubview(calendarImage)
        view.addSubview(saveButton)
        
        startDateView.addSubview(startDate)
        endDateView.addSubview(endDate)
        
        topView.addSubview(titleLabel)
        topView.addSubview(backButton)
        
        colorView.addSubview(colorHeading)
        colorView.addSubview(colorStackView)
        
        colorStackView.addArrangedSubview(red)
        colorStackView.addArrangedSubview(orange)
        colorStackView.addArrangedSubview(yellow)
        colorStackView.addArrangedSubview(green)
        colorStackView.addArrangedSubview(turquoise)
        colorStackView.addArrangedSubview(blue)
        colorStackView.addArrangedSubview(darkBlue)
        colorStackView.addArrangedSubview(purple)
        
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        titleLabel.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.centerX(in: topView)
        
        backButton.anchor(left: topView.leftAnchor, paddingLeft: 20)
        backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        titleTextField.anchor(top: topView.bottomAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20)
        titleTextField.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleTextField.layer.borderWidth = 5
        titleTextField.delegate = self
        
        colorView.centerX(in: view)
        colorView.setDimensions(height: 200)
        
        colorHeading.anchor(top: colorView.topAnchor, left: colorView.leftAnchor, paddingTop: 20)
        colorStackView.anchor(top: colorHeading.bottomAnchor, left: colorHeading.leftAnchor, paddingTop: 5)
        
        let startTap = UITapGestureRecognizer(target: self, action: #selector(startDateViewTapped))
        startDateView.setDimensions(width: UIScreen.main.bounds.width/2,
                                    height: UIScreen.main.bounds.height/15)
        startDateView.addGestureRecognizer(startTap)
        startDateView.anchor(top: titleTextField.bottomAnchor,
                             left: titleTextField.leftAnchor,
                             paddingTop: UIScreen.main.bounds.height/50)
        
        calendarImage.anchor(left: startDateView.leftAnchor, paddingLeft: 15)
        calendarImage.centerY(in: startDateView)
        calendarImage.tintColor = .darkGray
        
        let endTap = UITapGestureRecognizer(target: self, action: #selector(endDateViewTapped))
        endDateView.addGestureRecognizer(endTap)
        endDateView.layer.borderColor = UIColor.silver.cgColor
        endDateView.layer.borderWidth = 1
        endDateView.backgroundColor = .backgroundColor
        endDateView.setDimensions(width: UIScreen.main.bounds.width/2,
                                  height: UIScreen.main.bounds.height/15)
        
        endDateView.anchor(top: titleTextField.bottomAnchor,
                           right: view.rightAnchor,
                           paddingTop: UIScreen.main.bounds.height/50,
                           paddingRight: 20)
        
        startDate.centerX(in: startDateView)
        startDate.centerY(in: startDateView)
        startDate.text = formatDateNoDay(from: Date())
        
        var dateComponent = DateComponents()
        dateComponent.month = 3
        let threeMonthsFromToday = Calendar.current.date(byAdding: dateComponent, to: Date())
        endDate.centerXAnchor.constraint(equalTo: endDateView.centerXAnchor, constant: 10).isActive = true
        endDate.centerY(in: endDateView)
        endDate.text = formatDateNoDay(from: threeMonthsFromToday ?? Date())
        
        CourseService.shared.setStartDate(date: Date())
        CourseService.shared.setEndDate(date: threeMonthsFromToday ?? Date())
        
        datePickerView.anchor(top: startDateView.bottomAnchor)
        datePickerView.centerX(in: view)
        datePickerView.addTarget(self, action: #selector(datePickerDateChanged), for: .valueChanged)
        
        colorTopAnchorConstaint = colorView.topAnchor.constraint(equalTo: startDateView.bottomAnchor)
        colorOtherAnchorConstaint = colorView.topAnchor.constraint(equalTo: datePickerView.bottomAnchor)
        colorTopAnchorConstaint.isActive = true
        
        saveButton.centerX(in: view)
        saveButton.anchor(bottom: view.bottomAnchor, paddingBottom: 40)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        red.tag = 0
        orange.tag = 1
        yellow.tag = 2
        green.tag = 3
        turquoise.tag = 4
        blue.tag = 5
        darkBlue.tag = 6
        purple.tag = 7
        
        red.alpha = 0.3
        red.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        orange.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        yellow.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        green.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        turquoise.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        blue.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        darkBlue.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        purple.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        
        if let courseIndex = AllCoursesService.shared.getCourseIndex() {
            if let course = AllCoursesService.shared.getCourse(atIndex: courseIndex) {
                titleTextField.text = course.title
                
                startDate.text = formatDateNoDay(from: course.startDate)
                endDate.text = formatDateNoDay(from: course.endDate)
                CourseService.shared.setStartDate(date: course.startDate)
                CourseService.shared.setEndDate(date: course.endDate)
                titleLabel.text = "Edit Course"
                
                switch course.color {
                case 0:
                    colorButtonPressed(button: red)
                case 1:
                    colorButtonPressed(button: orange)
                case 2:
                    colorButtonPressed(button: yellow)
                case 3:
                    colorButtonPressed(button: green)
                case 4:
                    colorButtonPressed(button: turquoise)
                case 5:
                    colorButtonPressed(button: blue)
                case 6:
                    colorButtonPressed(button: darkBlue)
                case 7:
                    colorButtonPressed(button: purple)
                default:
                    break
                }
            }
        }
    }
    
    //MARK: - Actions
    @objc func datePickerDateChanged() {
        colorTopAnchorConstaint.isActive = false
        colorOtherAnchorConstaint.isActive = true
        
        if startDateView.color == UIColor.mainBlue {
            CourseService.shared.setStartDate(date: datePickerView.date)
            startDate.text = "\(formatDateNoDay(from: datePickerView.date))"
        } else {
            CourseService.shared.setEndDate(date: datePickerView.date)
            endDate.text  = "\(formatDateNoDay(from: datePickerView.date))"
        }
    }
    @objc func startDateViewTapped() {
        
        if startDateView.color != UIColor.mainBlue {
            datePickerView.date = CourseService.shared.getStartDate()
            startDateView.color = .mainBlue
            startDateView.borderColor = .clear
            calendarImage.tintColor = .white
            startDate.textColor = .backgroundColor
            endDate.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.colorView.frame.origin.y = self.datePickerView.frame.maxY
            })
        } else {
            startDateView.color = .clouds
            startDateView.borderColor = .silver
            calendarImage.tintColor = .darkGray
            startDate.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.colorView.frame.origin.y = self.startDateView.frame.maxY
            })
        }
        endDateView.backgroundColor = .backgroundColor
        endDateView.layer.borderColor = UIColor.silver.cgColor
    }
    
    @objc func endDateViewTapped() {
        if endDateView.backgroundColor != UIColor.mainBlue {
            datePickerView.date = CourseService.shared.getEndDate()
            endDateView.backgroundColor = .mainBlue
            endDateView.layer.borderColor = UIColor.clear.cgColor
            endDate.textColor = .backgroundColor
            startDate.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.colorView.frame.origin.y = self.datePickerView.frame.maxY
            })
        } else {
            endDateView.backgroundColor = .backgroundColor
            endDateView.layer.borderColor = UIColor.silver.cgColor
            endDate.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.colorView.frame.origin.y = self.startDateView.frame.maxY
            })
        }
        startDateView.color = .clouds
        startDateView.borderColor = .silver
        calendarImage.tintColor = .darkGray
    }
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonPressed() {
        do {
            try realm.write {
                let course = Course()
                if titleTextField.text != ""{
                    course.title = titleTextField.text ?? "Untitled"
                } else {
                    course.title = "Untitled"
                }
                course.startDate = CourseService.shared.getStartDate()
                course.endDate = CourseService.shared.getEndDate()
                course.color = CourseService.shared.getColor()
                
                if let courseToUpdate = AllCoursesService.shared.getSelectedCourse() {
                    courseToUpdate.startDate = course.startDate
                    courseToUpdate.endDate = course.endDate
                    courseToUpdate.color = course.color
                    courseToUpdate.title = course.title
                    let tasksToUpdate = realm.objects(Task.self).filter("course == %@ AND type == %@ OR type == %@ OR type == %@ OR type == %@", courseToUpdate.title, "Class", "quiz", "exam", "assignment")
                    
                    for task in tasksToUpdate {
                        task.color = course.color
                        
                        if task.type != "assignment"{
                            task.title = "\(course.title) \(task.type)"
                        }
                        
                        if task.startDate > courseToUpdate.endDate {
                            realm.delete(task)
                        }
                    }
                } else {
                    realm.add(course, update: .modified)
                }
            }
        } catch {
            print("Error saving course to realm \(error.localizedDescription)")
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func colorButtonPressed(button: UIButton) {
        red.alpha = 1
        orange.alpha = 1
        yellow.alpha = 1
        green.alpha = 1
        turquoise.alpha = 1
        blue.alpha = 1
        darkBlue.alpha = 1
        purple.alpha = 1
        
        button.alpha = 0.3
        CourseService.shared.setColor(int: button.tag)
    }
}

//MARK: - TextField Delegate
extension AddCourseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
