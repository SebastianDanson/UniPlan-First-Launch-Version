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
import SwipeCellKit

class CourseDetailsViewController: SwipeViewController {
    
    let realm = try! Realm()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SingleClassService.shared.setClassIndex(index: nil)
        AssignmentService.shared.setAssignmentIndex(index: nil)
        QuizService.shared.setQuizIndex(index: nil)
        ExamService.shared.setExamIndex(index: nil)
        tableView.reloadData()
    }
    
    //MARK: - Properties
    //table views
    let tableView = makeTableView(withRowHeight: 120)
    let topView = makeTopView(height: UIScreen.main.bounds.height/9)
    let titleLabel = makeTitleLabel(withText: "")
    let backButton = makeBackButton()
    let deleteButton = makeDeleteButton()
    
    //MARK: - UISetup
    func setupViews() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(topView)
        view.addSubview(backButton)
        view.addSubview(deleteButton)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.setDimensions(width: UIScreen.main.bounds.width)

        tableView.register(QuizAndExamCell.self, forCellReuseIdentifier: "QuizAndExam")
        tableView.register(AssignmentCell.self, forCellReuseIdentifier: "Assignment")
        tableView.register(SingleClassCell.self, forCellReuseIdentifier: "Class")
        tableView.separatorColor = .clear
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
        
        tableView.anchor(top:topView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
        let courseIndex = AllCoursesService.shared.getCourseIndex()
        let course = AllCoursesService.shared.getCourse(atIndex: courseIndex)
        titleLabel.text = course?.title
    }
    
    //MARK: - Actions
    @objc func AddClassButtonPressed() {
        let vc = AddClassViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func AddAssignmentButtonPressed() {
        let vc = AddAssignmentViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func AddExamButtonPressed() {
        CourseService.shared.setQuizOrExam(int: 1)
        let vc = AddQuizAndExamViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func AddQuizButtonPressed() {
        CourseService.shared.setQuizOrExam(int: 0)
        let vc = AddQuizAndExamViewController()
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
    override func updateModel(index: Int, section: Int) {
        do {
            try realm.write {
                switch section {
                case 0:
                    if let classToDelete = CourseService.shared.getClass(atIndex: index) {
                        realm.delete(classToDelete)
                        TaskService.shared.deleteTasks()
                        CourseService.shared.updateClasses()
                    }
                case 1:
                    if let assignmentToDelete = CourseService.shared.getAssignment(atIndex: index) {
                        realm.delete(assignmentToDelete)
                        CourseService.shared.updateAssignments()
                    }
                case 2:
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return CourseService.shared.getClasses()?.count ?? 0
        case 1:
            return CourseService.shared.getAssignments()?.count ?? 0
        case 2:
            return CourseService.shared.getQuizzes()?.count ?? 0
        case 3:
            return CourseService.shared.getExams()?.count ?? 0
        default:
            return 0
        }
    
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let sectionName = makeHeading(withText: "")
        let addButton = makeAddButtonWithFill()
        let seperator = makeSpacerView(height: 2)
        
        view.backgroundColor = .backgroundColor
        view.addSubview(sectionName)
        view.addSubview(addButton)
        view.addSubview(seperator)

        sectionName.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 10, paddingBottom: 5)
        addButton.anchor(left: sectionName.rightAnchor,  bottom: view.bottomAnchor,  paddingLeft: 5, paddingBottom: 5)
        
        seperator.backgroundColor = .silver
        seperator.anchor(top: view.topAnchor, paddingTop: 5)
        seperator.setDimensions(width: UIScreen.main.bounds.width - 20)
        seperator.centerX(in: view)
        
        switch section {
        case 0:
            seperator.alpha = 0
            sectionName.text = "Classes"
            addButton.addTarget(self, action: #selector(AddClassButtonPressed), for: .touchUpInside)
        case 1:
            sectionName.text = "Assignments"
            addButton.addTarget(self, action: #selector(AddAssignmentButtonPressed), for: .touchUpInside)
        case 2:
            sectionName.text = "Quizzes"
            addButton.addTarget(self, action: #selector(AddQuizButtonPressed), for: .touchUpInside)
        case 3:
            sectionName.text = "Exams"
            addButton.addTarget(self, action: #selector(AddExamButtonPressed), for: .touchUpInside)
        default:
            break
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 110
        case 1:
            return 75
        case 2:
            return 75
        default:
            return 75
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Class", for: indexPath) as! SingleClassCell
            if let theClass = CourseService.shared.getClass(atIndex: indexPath.row) {
                cell.update(theClass: theClass)
                cell.delegate = self
            }
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Assignment", for: indexPath) as! AssignmentCell
            if let assignment = CourseService.shared.getAssignment(atIndex: indexPath.row) {
                cell.update(assignment: assignment)
                cell.delegate = self
            }
            return cell

        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuizAndExam", for: indexPath) as! QuizAndExamCell
            if let quiz = CourseService.shared.getQuiz(atIndex: indexPath.row) {
                cell.update(quiz: quiz)
                cell.delegate = self
            }
            return cell

         default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuizAndExam", for: indexPath) as! QuizAndExamCell
            if let exam = CourseService.shared.getExam(atIndex: indexPath.row) {
                cell.update(exam: exam)
                cell.delegate = self
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.section)
        switch indexPath.section {
        case 0:
            SingleClassService.shared.setClassIndex(index: indexPath.row)
            AddClassButtonPressed()
        case 1:
            AssignmentService.shared.setAssignmentIndex(index: indexPath.row)
            AddAssignmentButtonPressed()
        case 2:
            QuizService.shared.setQuizIndex(index: indexPath.row)
            AddQuizButtonPressed()
        case 3:
            ExamService.shared.setExamIndex(index: indexPath.row)
            AddExamButtonPressed()
        default:
            break
        }
    }
}
