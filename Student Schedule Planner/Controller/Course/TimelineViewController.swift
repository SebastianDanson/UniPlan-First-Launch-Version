//
//  TimelineViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-02.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import FSCalendar

let reuseIdentifer = "TaskCell"
let courseReuseIdentifer = "CourseCell"

/*
 * This VC displays a Calendar and displays the users schedule for the selected day
 * The user can also add, edit, and delete each of the events
 */

class TimelineViewController: SwipeViewController  {
    let realm = try! Realm()
    
    //MARK: - Properties
    var tableView = makeTableView(withRowHeight: 80)
    let topView = makeTopView(height: UIScreen.main.bounds.height/5.5)
    let addButton = makeAddButton()
    let calendar = makeCalendar()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TaskService.shared.loadTasks()
        tableView.reloadData()
        TaskService.shared.setDateSelected(date: Date())
        TaskService.shared.setTaskIndex(index: nil)
        TaskService.shared.setReminderTime([0, 0]) //First index is hours, second is minutes
        TaskService.shared.setReminderDate(date: Date())
        TaskService.shared.setDateOrTime(scIndex: 0) //0 means time was selected, non zero means date was selected
        TaskService.shared.setHideReminder(bool: true)
        TaskService.shared.setCheckForTimeConflict(bool: true)
    }
    
    //MARK: - setup UI
    func setupViews() {
        tableView.isScrollEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .backgroundColor
        
        view.addSubview(topView)
        view.addSubview(tableView)
        topView.addSubview(calendar)
        topView.addSubview(addButton)
        
        calendar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        calendar.delegate = self
        calendar.dataSource = self
        
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        addButton.anchor(right: topView.rightAnchor, paddingRight: 20)
        addButton.centerYAnchor.constraint(equalTo: calendar.calendarHeaderView.centerYAnchor).isActive = true
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        tableView.centerX(in: view)
        tableView.anchor(top: topView.bottomAnchor, paddingTop: 5)
        tableView.rowHeight = UITableView.automaticDimension //Allows tableView cells to have a dynamic size
        tableView.estimatedRowHeight = 80
        tableView.setDimensions(width: view.frame.width, height: view.frame.height - topView.frame.height - (2 * self.tabBarHeight))
        tableView.register(TaskCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func updateModel(index: Int, section: Int) {
        do {
            try self.realm.write {
                //Deletes task and the summative associated with that task if there is one
                if let taskToDelete = TaskService.shared.getTask(atIndex: index) {
                    switch taskToDelete.type {
                    case "assignment":
                        let assignmentToDelete = realm.objects(Assignment.self).filter("id == %@", taskToDelete.summativeId).first
                        if let assignmentToDelete = assignmentToDelete {
                            realm.delete(assignmentToDelete)
                        }
                    case "quiz":
                        let quizToDelete = realm.objects(Quiz.self).filter("id == %@", taskToDelete.summativeId).first
                        if let quizToDelete = quizToDelete {
                            realm.delete(quizToDelete)
                        }
                    case "exam":
                        let examToDelete = realm.objects(Exam.self).filter("id == %@", taskToDelete.summativeId).first
                        if let examToDelete = examToDelete {
                            realm.delete(examToDelete)
                        }
                    default:
                        break
                    }
                    self.realm.delete(taskToDelete)
                    self.tableView.reloadData()
                }
            }
        } catch {
            print("Error writing task to realm")
        }
    }
    
    //MARK: - Actions
    @objc func addButtonTapped() {
        let vc = AddTaskViewController()
        vc.modalPresentationStyle = .fullScreen 
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK: - Tableview Delegate and Datasource
extension TimelineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        TaskService.shared.loadTasks()
        if TaskService.shared.getTasks()?.count == 0 {
            
            //If the user has no events for that Day it says so
            let noCoursesLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 100))
            noCoursesLabel.text = "No Events Scheduled"
            noCoursesLabel.textColor = UIColor.darkBlue
            noCoursesLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            noCoursesLabel.textAlignment = .center
            tableView.tableHeaderView = noCoursesLabel
            tableView.separatorStyle  = .none
            return 0
        }
        tableView.tableHeaderView = nil
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskService.shared.getTasks()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! TaskCell
        if let task = TaskService.shared.getTask(atIndex: indexPath.row) {
            cell.update(task: task, summative: false)
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TaskService.shared.setTaskIndex(index: indexPath.row)
        
        let task = TaskService.shared.getTask(atIndex: indexPath.row)
        if let task = task {
            var vc = UIViewController()
            
            //If the user selects a task associated with a summative
            switch task.type {
            case "assignment":
                let assignment = realm.objects(Assignment.self).filter("id == %@", task.summativeId).first
                
                CourseService.shared.setSelectedAssignment(assignment: assignment)
                vc = AddAssignmentViewController()
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
            case "quiz":
                let quiz = realm.objects(Quiz.self).filter("id == %@", task.summativeId).first
                
                CourseService.shared.setSelectedQuiz(quiz: quiz)
                CourseService.shared.setQuizOrExam(int: 0)
                
                vc = AddQuizAndExamViewController()
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
            case "exam":
                let exam = realm.objects(Exam.self).filter("id == %@", task.summativeId).first
                
                CourseService.shared.setSelectedExam(exam: exam)
                CourseService.shared.setQuizOrExam(int: 1)
                
                vc = AddQuizAndExamViewController()
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
            default:
                addButtonTapped()
            }
        }
    }
}

//MARK: - FSCalendar Delegate and Datasource
extension TimelineViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        TaskService.shared.setDateSelected(date: date)
        TaskService.shared.loadTasks()
        tableView.reloadData()
    }
}
