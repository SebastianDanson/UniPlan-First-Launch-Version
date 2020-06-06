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

let reuseIdentifer = "TaskCell"
var tasks: Results<Task>!
class TimelineViewController: UIViewController {
    let realm = try! Realm()
    
    //MARK: - Properties
    var numSection = 1
    let tableView = UITableView()
    let titleLabel = makeTitleLabel(withText: "Today")
    let topView = makeTopView(height: 160)
    let datebox = CalendarView()
    let addButton = makeAddButton()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTasks()
    }
    
    //MARK: - setup UI
    func setupViews() {
        taskIndex = nil
        view.backgroundColor = .backgroundColor
        
        view.addSubview(topView)
        
        topView.addSubview(datebox)
        topView.addSubview(titleLabel)
        topView.addSubview(addButton)
        
        topView.anchor(top: view.topAnchor)
        topView.centerX(in: view)
        
        titleLabel.anchor(top: topView.topAnchor, paddingTop: 40)
        titleLabel.centerX(in: topView)
        
        datebox.anchor(top: titleLabel.bottomAnchor, left: topView.leftAnchor, right: topView.rightAnchor, paddingTop: 20, paddingLeft: 12, paddingRight: -12)
        
        addButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        addButton.anchor(right: topView.rightAnchor, paddingRight: 20)
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
    
    //MARK: - Helper Functions
    func loadTasks() {
        tasks = realm.objects(Task.self).sorted(byKeyPath: "startDate", ascending: true)
        tableView.reloadData()
    }
}

//MARK: - Tableview Delegate and Datasource
extension TimelineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        cell.update(task: tasks[indexPath.row])
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskIndex = indexPath.row
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
                
                    self.realm.delete(tasks[indexPath.row])
                    tableView.reloadData()
                    }
                
            } catch {
                print("Error writing task to realm")
            }
        }
        deleteAction.image = UIImage(named: "Trash")
        
        return [deleteAction]
    }
}
