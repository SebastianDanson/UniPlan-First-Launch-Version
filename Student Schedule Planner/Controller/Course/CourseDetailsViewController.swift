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

/*
 * This VC displays all of the classes, assignments, quizzes and exam for that class and
 * allows the user to add more or delete any of them, as well as edit the course details
 */
class CourseDetailsViewController: SwipeCompleteViewController {
    
    let realm = try! Realm()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SingleClassService.shared.setClassIndex(index: nil)
        SingleClassService.shared.setType(classType: .Class)
        TaskService.shared.setReminderTime([0, 0])
        TaskService.shared.setReminderDate(date: Date())
        SingleClassService.shared.setReminder(false)
        CourseService.shared.setSelectedAssignment(assignment: nil)
        CourseService.shared.setSelectedQuiz(quiz: nil)
        CourseService.shared.setSelectedExam(exam: nil)
        
        let course = AllCoursesService.shared.getSelectedCourse()
        let color = UIColor.init(red: CGFloat(course?.color[0] ?? 0), green: CGFloat(course?.color[1] ?? 0), blue: CGFloat(course?.color[2] ?? 0), alpha: 1)
        topView.backgroundColor = color
        
        titleLabel.text = AllCoursesService.shared.getSelectedCourse()?.title ?? ""
        tableView.reloadData()
    }
    
    //MARK: - Properties
    //table views
    let tableView = makeTableView(withRowHeight: 120)
    let topView = makeTopView(height: UIScreen.main.bounds.height/8.5)
    let titleLabel = makeTitleLabel(withText: "")
    let backButton = makeBackButton()
    
    let editButton: UIButton = {
        let editButton = UIButton()
        editButton.setTitle("Edit", for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        editButton.setDimensions(width: 50, height: 30)
        editButton.backgroundColor = .clear
        editButton.setTitleColor(UIColor.backgroundColor, for: .normal)
        return editButton
    }()
    
    //MARK: - UISetup
    func setupViews() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(topView)
        view.addSubview(backButton)
        view.addSubview(editButton)
        view.addSubview(tableView)
        
        tableView.backgroundColor = .backgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.setDimensions(width: UIScreen.main.bounds.width)
        
        tableView.register(QuizAndExamCell.self, forCellReuseIdentifier: "QuizAndExam")
        tableView.register(AssignmentCell.self, forCellReuseIdentifier: "Assignment")
        tableView.register(SingleClassCell.self, forCellReuseIdentifier: "Class")
        tableView.register(NoteCell.self, forCellReuseIdentifier: "Note")
        
        tableView.separatorColor = .clear
        topView.addSubview(titleLabel)
        
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        titleLabel.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.setDimensions(width: UIScreen.main.bounds.width * 0.65)
        titleLabel.textAlignment = .center
        titleLabel.centerX(in: topView)
        
        backButton.anchor(left: topView.leftAnchor, paddingLeft: 20)
        backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        editButton.anchor(right: topView.rightAnchor, paddingRight: 20)
        editButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        
        tableView.anchor(top:topView.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         bottom: view.bottomAnchor)
    }
    
    //MARK: - Actions
    @objc func AddClassButtonPressed() {
        RoutineService.shared.setIsRoutine(bool: false)
        let vc = AddClassViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func AddAssignmentButtonPressed(button: UIButton? = nil) {
        if button != nil {
            CourseService.shared.setSelectedAssignment(assignment: nil)
        }
        
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
    
    @objc func AddNoteButtonPressed() {
        let vc = AddNotesViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func editButtonPressed() {
        let vc = AddCourseViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func backButtonPressed() {
        if let nav = navigationController {
            nav.popViewController(animated: true)
        }
    }
    
    @objc func deleteCourse() {
        let index = AllCoursesService.shared.getCourseIndex()
        let alert = UIAlertController(title: "Are You Sure You Want To Delete This Course?", message: "", preferredStyle: .alert)
        let actionDeleteCourse = UIAlertAction(title: "Delete", style: .default) { (alert) in
            do {
                try self.realm.write {
                    if let index = index {
                        if let courseToDelete = AllCoursesService.shared.getCourse(atIndex: index) {
                            self.realm.delete(courseToDelete)
                            AllCoursesService.shared.updateCourses()
                        }
                    }
                }
            } catch {
                print("Error writing task to realm \(error.localizedDescription)")
            }
            self.backButtonPressed()
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
                //Deletes the specified object as well as the task(s) associated with them
                switch section {
                case 0:
                    if let classToDelete = CourseService.shared.getClass(atIndex: index) {
                        TaskService.shared.deleteTasks(forClass: classToDelete)
                        realm.delete(classToDelete)
                        CourseService.shared.updateClasses()
                    }
                case 1:
                    if let assignmentToDelete = CourseService.shared.getAssignment(atIndex: index) {
                        TaskService.shared.deleteTasks(forAssigment: assignmentToDelete)
                        realm.delete(assignmentToDelete)
                        CourseService.shared.updateAssignments()
                    }
                case 2:
                    if let quizToDelete = CourseService.shared.getQuiz(atIndex: index) {
                        TaskService.shared.deleteTasks(forQuiz: quizToDelete)
                        realm.delete(quizToDelete)
                        CourseService.shared.updateQuizzes()
                    }
                case 4:
                    if let noteToDelete = CourseService.shared.getNote(atIndex: index) {
                        realm.delete(noteToDelete)
                        CourseService.shared.updateNotes()
                    }
                default:
                    if let examToDelete = CourseService.shared.getExam(atIndex: index) {
                        TaskService.shared.deleteTasks(forExam: examToDelete)
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
    
    override func complete(index: Int, section: Int) {
        do {
            try realm.write{
                switch section {
                case 1:
                    if let assignmentToComplete = CourseService.shared.getAssignment(atIndex: index) {
                        assignmentToComplete.isComplete = true
                        TaskService.shared.updateTasks(forAssignment: assignmentToComplete)
                    }
                case 2:
                    if let quizToComplete = CourseService.shared.getQuiz(atIndex: index) {
                        quizToComplete.isComplete = true
                        TaskService.shared.updateTasks(forQuiz: quizToComplete)
                    }
                case 3:
                    if let examToComplete = CourseService.shared.getExam(atIndex: index) {
                        examToComplete.isComplete = true
                        TaskService.shared.updateTasks(forExam: examToComplete)
                    }
                default:
                    break
                }
            }
        } catch {
            print("Error updating isComplete in CourseDetailsView, \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    //MARK: - SwipeCellDelegate
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
           if orientation == .right {
               
           let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
               self.updateModel(index: indexPath.row, section: indexPath.section)
           }
           deleteAction.image = UIImage(named: "Trash")
           
           return [deleteAction]
           } else if orientation == .left {
               if indexPath.section != 0, indexPath.section != 4 {
               let completeAction = SwipeAction(style: .default, title: "Complete") { action, indexPath in
                   self.complete(index: indexPath.row, section: indexPath.section)
               }
               completeAction.image = UIImage(systemName: "checkmark.circle.fill")
               completeAction.backgroundColor = .emerald
               return [completeAction]
               }
           }
           return nil
       }
       
    override func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
           var options = SwipeOptions()
           
           if orientation == .right {
           options.expansionStyle = .destructive(automaticallyDelete: false)
           } else if orientation == .left {
               options.expansionStyle = .selection
           }
           return options
               
       }
}
    
    //MARK: - Tableview Delegate and Datasource
    extension CourseDetailsViewController: UITableViewDelegate, UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int {
            return 5
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
            case 4:
                return CourseService.shared.getNotes()?.count ?? 0
            default:
                return 0
            }
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let view = UIView()
            let sectionName = makeHeading(withText: "")
            let addButton = makeCornerAddButton(withDiameter: 35)
            let seperator = makeSpacerView(height: 2)
            
            view.backgroundColor = .backgroundColor
            view.addSubview(sectionName)
            view.addSubview(addButton)
            view.addSubview(seperator)
            
            sectionName.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 10, paddingBottom: 5)
            addButton.anchor(left: sectionName.rightAnchor, paddingLeft: 5)
            addButton.centerYAnchor.constraint(equalTo: sectionName.centerYAnchor).isActive = true
            
            let course = AllCoursesService.shared.getSelectedCourse()
            let color = UIColor.init(red: CGFloat(course?.color[0] ?? 0), green: CGFloat(course?.color[1] ?? 0), blue: CGFloat(course?.color[2] ?? 0), alpha: 1)
            addButton.tintColor = color
            
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
                CourseService.shared.setSelectedQuiz(quiz: nil)
                addButton.addTarget(self, action: #selector(AddQuizButtonPressed), for: .touchUpInside)
            case 3:
                sectionName.text = "Exams"
                CourseService.shared.setSelectedExam(exam: nil)
                addButton.addTarget(self, action: #selector(AddExamButtonPressed), for: .touchUpInside)
            case 4:
                sectionName.text = "Notes"
                CourseService.shared.setSelectedNote(note: nil)
                addButton.addTarget(self, action: #selector(AddNoteButtonPressed), for: .touchUpInside)
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
                tableView.estimatedRowHeight = 75
                return UITableView.automaticDimension
            case 2:
                return 65
            case 4:
                tableView.estimatedRowHeight = 50
                return UITableView.automaticDimension
            default:
                return 65
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
                
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath) as! NoteCell
                if let note = CourseService.shared.getNote(atIndex: indexPath.row) {
                    cell.update(note: note)
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
            switch indexPath.section {
            case 0:
                SingleClassService.shared.setClassIndex(index: indexPath.row)
                AddClassButtonPressed()
            case 1:
                CourseService.shared.setAssignmentIndex(index: indexPath.row)
                AddAssignmentButtonPressed()
            case 2:
                CourseService.shared.setQuizIndex(index: indexPath.row)
                AddQuizButtonPressed()
            case 3:
                CourseService.shared.setExamIndex(index: indexPath.row)
                AddExamButtonPressed()
            case 4:
                CourseService.shared.setNoteIndex(index: indexPath.row)
                AddNoteButtonPressed()
            default:
                break
            }
        }
}
