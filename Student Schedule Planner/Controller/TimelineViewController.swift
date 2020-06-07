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

class TimelineViewController: UIViewController  {
    let realm = try! Realm()
    
    //MARK: - Properties
    let tableView = UITableView()
    let topView = makeTopView(height: 135)
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
        }
    
    //MARK: - setup UI
    func setupViews() {
        
        view.backgroundColor = .backgroundColor
        
        view.addSubview(topView)
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
        
        setupTableView()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.separatorColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.register(TaskCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.centerX(in: view)
        tableView.anchor(top: topView.bottomAnchor, paddingTop: 5)
        tableView.setDimensions(width: view.frame.width, height: view.frame.height - topView.frame.height)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskService.shared.getTasks()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        if let task = TaskService.shared.getTask(atIndex: indexPath.row) {
            cell.update(task: task)
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TaskService.shared.setTaskIndex(index: indexPath.row)
        addButtonTapped()
    }
}

//MARK: - Swipe Cell Delegate Methods
extension TimelineViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            do {
                try self.realm.write {
                    if let taskToDelete = TaskService.shared.getTask(atIndex: indexPath.row) {
                        self.realm.delete(taskToDelete)
                        tableView.reloadData()
                    }
                }
                
            } catch {
                print("Error writing task to realm")
            }
        }
        deleteAction.image = UIImage(named: "Trash")
        
        return [deleteAction]
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
