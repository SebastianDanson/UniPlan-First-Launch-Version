//
//  CourseDetailsViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-11.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class CourseDetailsViewController: SwipeViewController {
    
    let realm = try! Realm()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        classTableView.reloadData()
        assignmentsTableView.reloadData()
        quizzesTableView.reloadData()
        examsTableView.reloadData()
        SingleClassService.shared.setClassIndex(index: nil)
        AssignmentService.shared.setAssignmentIndex(index: nil)
        QuizService.shared.setQuizIndex(index: nil)
        ExamService.shared.setExamIndex(index: nil)
    }
    
    //MARK: - Properties
    //table views
    let classTableView = makeTableView(withRowHeight: 110)
    let assignmentsTableView = makeTableView(withRowHeight: 75)
    let quizzesTableView = makeTableView(withRowHeight: 55)
    let examsTableView = makeTableView(withRowHeight: 55)
    
    let topView = makeTopView(height: UIScreen.main.bounds.height/9)
    let titleLabel = makeTitleLabel(withText: "")
    let backButton = makeBackButton()
    let deleteButton = makeDeleteButton()
    
    //Headings
    let classesHeading = makeHeading(withText: "Classes")
    let assignmentsHeading = makeHeading(withText: "Assignments")
    let quizzesHeading = makeHeading(withText: "Quizzes")
    let examsHeading = makeHeading(withText: "Exams")
    
    //Add Buttons
    let classesAddButton = makeAddButtonWithFill()
    let assignmentsAddButton = makeAddButtonWithFill()
    let quizzesAddButton = makeAddButtonWithFill()
    let examsAddButton = makeAddButtonWithFill()
    
    //MARK: - UISetup
    func setupViews() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(topView)
        view.addSubview(backButton)
        view.addSubview(deleteButton)
        view.addSubview(classesHeading)
        view.addSubview(assignmentsHeading)
        view.addSubview(quizzesHeading)
        view.addSubview(examsHeading)
        view.addSubview(classTableView)
        view.addSubview(assignmentsTableView)
        view.addSubview(quizzesTableView)
        view.addSubview(examsTableView)
        view.addSubview(classesAddButton)
        view.addSubview(assignmentsAddButton)
        view.addSubview(quizzesAddButton)
        view.addSubview(examsAddButton)
        
        topView.addSubview(titleLabel)
        
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        titleLabel.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.centerX(in: topView)
        backButton.anchor(left: topView.leftAnchor, paddingLeft: 20)
        backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        deleteButton.anchor(right: topView.rightAnchor, paddingRight: 20)
        deleteButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        deleteButton.addTarget(self, action: #selector(deleteCourse), for: .touchUpInside)
        
        //Classes Section
        classesHeading.anchor(top: topView.bottomAnchor, left: view.leftAnchor, paddingTop: UIScreen.main.bounds.height/55, paddingLeft: 20)
        classesAddButton.anchor(left: classesHeading.rightAnchor, paddingLeft: 7)
        classesAddButton.centerYAnchor.constraint(equalTo: classesHeading.centerYAnchor).isActive = true
        classesAddButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
        classTableView.centerX(in: view)
        classTableView.anchor(top: classesHeading.bottomAnchor, paddingTop: 5)
        classTableView.setDimensions(width: view.frame.width, height: classTableView.rowHeight )
        classTableView.register(SingleClassCell.self, forCellReuseIdentifier: reuseIdentifer)
        classTableView.delegate = self
        classTableView.dataSource = self
        
        //Assignments Section
        assignmentsHeading.anchor(top: classTableView.bottomAnchor, left: view.leftAnchor, paddingTop: UIScreen.main.bounds.height/55, paddingLeft: 20)
        assignmentsAddButton.anchor(left: assignmentsHeading.rightAnchor, paddingTop: 15,paddingLeft: 7)
        assignmentsAddButton.centerYAnchor.constraint(equalTo: assignmentsHeading.centerYAnchor).isActive = true
        assignmentsAddButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        assignmentsTableView.centerX(in: view)
        assignmentsTableView.anchor(top: assignmentsHeading.bottomAnchor, paddingTop: 5)
        assignmentsTableView.setDimensions(width: view.frame.width, height: assignmentsTableView.rowHeight)
        assignmentsTableView.register(AssignmentCell.self, forCellReuseIdentifier: reuseIdentifer)
        assignmentsTableView.delegate = self
        assignmentsTableView.dataSource = self
        
        //Quizzes Section
        quizzesHeading.anchor(top: assignmentsTableView.bottomAnchor, left: view.leftAnchor, paddingTop: UIScreen.main.bounds.height/55, paddingLeft: 20)
        quizzesAddButton.anchor(left: quizzesHeading.rightAnchor, paddingLeft: 7)
        quizzesAddButton.centerYAnchor.constraint(equalTo: quizzesHeading.centerYAnchor).isActive = true
        quizzesAddButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        quizzesTableView.centerX(in: view)
        quizzesTableView.anchor(top: quizzesHeading.bottomAnchor, paddingTop: 5)
        quizzesTableView.setDimensions(width: view.frame.width, height: quizzesTableView.rowHeight)
        quizzesTableView.register(QuizAndExamCell.self, forCellReuseIdentifier: reuseIdentifer)
        quizzesTableView.delegate = self
        quizzesTableView.dataSource = self
        
        //Exams Section
        examsHeading.anchor(top: quizzesTableView.bottomAnchor, left: view.leftAnchor, paddingTop: UIScreen.main.bounds.height/55, paddingLeft: 20)
        examsAddButton.anchor(left: examsHeading.rightAnchor, paddingLeft: 7)
        examsAddButton.centerYAnchor.constraint(equalTo: examsHeading.centerYAnchor).isActive = true
        examsAddButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        examsTableView.centerX(in: view)
        examsTableView.anchor(top: examsHeading.bottomAnchor, paddingTop: 5)
        examsTableView.setDimensions(width: view.frame.width, height: examsTableView.rowHeight)
        examsTableView.register(QuizAndExamCell.self, forCellReuseIdentifier: reuseIdentifer)
        examsTableView.delegate = self
        examsTableView.dataSource = self
        
        let courseIndex = AllCoursesService.shared.getCourseIndex()
        let course = AllCoursesService.shared.getCourse(atIndex: courseIndex)
        titleLabel.text = course?.title
    }
    
    //MARK: - Actions
    @objc func addButtonPressed(button: UIButton) {
        var vc = UIViewController()
        switch button {
        case classesAddButton:
            vc = AddClassViewController()
        case assignmentsAddButton:
            vc = AddAssignmentViewController()
        case quizzesAddButton:
            vc = AddQuizAndExamViewController()
            CourseService.shared.setQuizOrExam(int: 0)
        case examsAddButton:
            vc = AddQuizAndExamViewController()
            CourseService.shared.setQuizOrExam(int: 1)
        default:
            vc = AddQuizAndExamViewController()
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func deleteCourse() {
        let index = AllCoursesService.shared.getCourseIndex()
         let alert = UIAlertController(title: "Are You Sure You Want To Delete This Course?", message: "", preferredStyle: .alert)
               let actionDeleteCourse = UIAlertAction(title: "Delete", style: .default) { (alert) in
                   do {
                       try self.realm.write {
                           if let courseToDelete = AllCoursesService.shared.getCourse(atIndex: index) {
                               self.realm.delete(courseToDelete)
                               AllCoursesService.shared.updateCourses()
                           }
                       }
                   } catch {
                       print("Error writing task to realm")
                   }
                self.dismiss(animated: true, completion: nil)
               }
               
               let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (alert) in }

               alert.addAction(actionCancel)
               alert.addAction(actionDeleteCourse)
               present(alert, animated: true)
    }
    
    //MARK: - Helper Functions
    //What happens when you swipe on a cell
    override func updateModel(index: Int, tableView: UITableView) {
        do {
            try realm.write {
                switch tableView {
                case classTableView:
                    if let classToDelete = CourseService.shared.getClass(atIndex: index) {
                        realm.delete(classToDelete)
                        TaskService.shared.deleteTasks()
                        CourseService.shared.updateClasses()
                    }
                case assignmentsTableView:
                    if let assignmentToDelete = CourseService.shared.getAssignment(atIndex: index) {
                        realm.delete(assignmentToDelete)
                        CourseService.shared.updateAssignments()
                    }
                case quizzesTableView:
                    if let quizToDelete = CourseService.shared.getQuiz(atIndex: index) {
                        realm.delete(quizToDelete)
                        CourseService.shared.updateQuizzes()
                    }
                default:
                    if let examToDelete = CourseService.shared.getExam(atIndex: index) {
                        realm.delete(examToDelete)
                        CourseService.shared.updateExams()
                    }
                }
            }
        } catch {
            print("Error writing to Realm \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
}

//MARK: - Tableview Delegate and Datasource
extension CourseDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case classTableView:
            return CourseService.shared.getClasses()?.count ?? 0
        case assignmentsTableView:
            return CourseService.shared.getAssignments()?.count ?? 0
        case quizzesTableView:
            return CourseService.shared.getQuizzes()?.count ?? 0
        case examsTableView:
            return CourseService.shared.getExams()?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case classTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! SingleClassCell
            if let theClass = CourseService.shared.getClass(atIndex: indexPath.row) {
                cell.update(theClass: theClass)
                cell.delegate = self
            }
            return cell
            
        case assignmentsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! AssignmentCell
            if let assignment = CourseService.shared.getAssignment(atIndex: indexPath.row) {
                cell.update(assignment: assignment)
                cell.delegate = self
            }
            return cell
            
        case quizzesTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! QuizAndExamCell
            if let quiz = CourseService.shared.getQuiz(atIndex: indexPath.row) {
                cell.update(quiz: quiz)
                cell.delegate = self
            }
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! QuizAndExamCell
            if let exam = CourseService.shared.getExam(atIndex: indexPath.row) {
                cell.update(exam: exam)
                cell.delegate = self
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case classTableView:
            SingleClassService.shared.setClassIndex(index: indexPath.row)
            addButtonPressed(button: classesAddButton)
        case assignmentsTableView:
            AssignmentService.shared.setAssignmentIndex(index: indexPath.row)
            addButtonPressed(button: assignmentsAddButton)
        case quizzesTableView:
            QuizService.shared.setQuizIndex(index: indexPath.row)
            addButtonPressed(button: quizzesAddButton)
        case examsTableView:
            ExamService.shared.setExamIndex(index: indexPath.row)
            addButtonPressed(button: examsAddButton)
        default:
            break
        }
    }
}
