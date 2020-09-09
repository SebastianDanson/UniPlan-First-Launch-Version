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

class TimelineViewController: SwipeCompleteViewController {
    
    let realm = try! Realm()
    
    //MARK: - Properties
    var tableView = makeTableView(withRowHeight: 80)
    let topView = UIView()
    let calendar = makeCalendar()
    let pullDownView = UIView()
    let addButton = makeCornerAddButton()
    let weekButton = UIButton()
    
    var topViewWeekHeightAnchor = NSLayoutConstraint()
    var topViewMonthHeightAnchor = NSLayoutConstraint()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(didActivate), name: UIScene.didActivateNotification, object: nil)
        
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        TaskService.shared.loadTasks()
        tableView.reloadData()
        calendar.select(TaskService.shared.getDateSelected())
        TaskService.shared.setTaskIndex(index: nil)
        TaskService.shared.setReminderTime([0, 0]) //First index is hours, second is minutes
        TaskService.shared.setReminderDate(date: Date())
        TaskService.shared.setDateOrTime(scIndex: 0) //0 means time was selected, non zero means date was selected
        TaskService.shared.setHideReminder(bool: true)
        TaskService.shared.setCheckForTimeConflict(bool: true)
    }
    
    //MARK: - setup UI
    func setupViews() {
        checkForFirstLaunch()
        tableView.isScrollEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .backgroundColor
        
        view.addSubview(topView)
        view.addSubview(tableView)
        view.addSubview(addButton)
        
        topView.addSubview(calendar)
        topView.addSubview(pullDownView)
        topView.addSubview(weekButton)
        
        pullDownView.anchor(bottom: topView.bottomAnchor, paddingBottom: 3)
        pullDownView.centerX(in: topView)
        pullDownView.setDimensions(width: UIScreen.main.bounds.width/5, height: 5)
        pullDownView.layer.cornerRadius = 2.5
        pullDownView.backgroundColor = .white
        
        topView.backgroundColor = .mainBlue
        topView.setDimensions(width: UIScreen.main.bounds.width)
        
        topViewWeekHeightAnchor = topView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/5)
        topViewMonthHeightAnchor = topView.heightAnchor.constraint(equalToConstant: calendar.bounds.height + UIScreen.main.bounds.height/20)
        topViewWeekHeightAnchor.isActive = true
        
        calendar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        calendar.delegate = self
        calendar.dataSource = self
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(calendarSwipeUp))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(calendarSwipeDown))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        let weekLabel = makeLabel(ofSize: 15, weight: .bold)
        weekLabel.text = "Week View"
        weekLabel.textColor = .mainBlue
        weekButton.addSubview(weekLabel)
        weekButton.backgroundColor = .white
        weekButton.setDimensions(width: 105, height: 35)
        weekButton.layer.cornerRadius = 17.5
        weekButton.layer.borderColor = UIColor.silver.cgColor
        weekButton.layer.borderWidth = 2
        weekButton.anchor(left: topView.leftAnchor, paddingLeft: 10)
        weekButton.centerY(in: calendar.calendarHeaderView)
        weekButton.addTarget(self, action: #selector(weekButtonTapped), for: .touchUpInside)
        
        weekLabel.centerX(in: weekButton)
        weekLabel.centerY(in: weekButton)
        
        addButton.anchor(right: view.rightAnchor,
                         bottom: view.bottomAnchor,
                         paddingRight: 10,
                         paddingBottom: self.tabBarHeight + 10)
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
        if let taskToDelete = TaskService.shared.getTask(atIndex: index) {
            TaskService.shared.deleteSummativeForTask(taskToDelete: taskToDelete, type: taskToDelete.type)
            self.tableView.reloadData()
        }
    }
    
    override func complete(index: Int, section: Int) {
        if let taskToComplete = TaskService.shared.getTask(atIndex: index) {
            TaskService.shared.setSummativeIsComplete(task: taskToComplete, type: taskToComplete.type)
            tableView.reloadData()
        }
    }
    
    //MARK: - Actions
    func checkForFirstLaunch() {
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: "Not First Launch"){
            
            let task1 = Task()
            task1.title = "Swipe left on tasks to delete"
            let rgb = UIColor.lightAlizarin.components
            task1.color[0] = Double(rgb.red)
            task1.color[1] = Double(rgb.green)
            task1.color[2] = Double(rgb.blue)
            
            let task2 = Task()
            task2.title = "Swipe right on tasks to complete"
            task2.isComplete = true
            task2.color[0] = Double(rgb.red)
            task2.color[1] = Double(rgb.green)
            task2.color[2] = Double(rgb.blue)
            do {
                try realm.write {
                    realm.add(task1)
                    realm.add(task2)
                }
            } catch {
                print("ERROR writing first launch tasks to Realm: \(error.localizedDescription)")
            }
            defaults.set(true, forKey: "Not First Launch")
        }
    }
    @objc func weekButtonTapped() {
        
        if let nav = navigationController {
            nav.pushViewController(WeekPageViewController(), animated: true)
        }
    }
    
    @objc func calendarSwipeDown() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            self.topViewWeekHeightAnchor.isActive = false
            self.topViewMonthHeightAnchor.isActive = true
            self.view.layoutIfNeeded()
        })
        calendar.scope = .month
    }
    
    @objc func calendarSwipeUp() {
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.topViewWeekHeightAnchor.isActive = true
            self.topViewMonthHeightAnchor.isActive = false
            self.view.layoutIfNeeded()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35, execute: {
            self.calendar.scope = .week
        })
    }
    
    @objc func addButtonTapped() {
        TaskService.shared.setDateOrTime(scIndex: 0)
        TaskService.shared.setReminderDate(date: Date())
        TaskService.shared.setReminderTime([0,0])
        
        let vc = AddTaskViewController()
        vc.modalPresentationStyle = .fullScreen 
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func didActivate() {
        TaskService.shared.setNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
                vc = AddTaskViewController()
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)                
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
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        TaskService.shared.setfirstDayOfWeek(date: calendar.currentPage)
    }
    
}
