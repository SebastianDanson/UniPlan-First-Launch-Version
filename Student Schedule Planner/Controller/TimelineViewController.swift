//
//  TimelineViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-02.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift

let reuseIdentifer = "TaskCell"
class TimelineViewController: UIViewController {
    let realm = try! Realm()
    var tasks: Results<Task>!
    
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
        
        view.backgroundColor = .backgroundColor
        
        view.addSubview(topView)
        
        topView.addSubview(datebox)
        topView.addSubview(titleLabel)
        topView.addSubview(addButton)
        
        topView.anchor(top: view.topAnchor)
        topView.centerX(in: view)
        
        titleLabel.anchor(top: topView.topAnchor, paddingTop: 40)
        titleLabel.centerX(in: topView)
        
        datebox.anchor(top: titleLabel.bottomAnchor, left: topView.leftAnchor, right: topView.rightAnchor, paddingTop: 20,paddingLeft: 12, paddingRight: -12)
        
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
        tasks = realm.objects(Task.self)
        tableView.reloadData()
    }
}

//MARK: - Tableview Delegate and Datasource
extension TimelineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskCell
        cell.update(task: tasks[indexPath.row])
            return cell
    
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskCell
//        cell.update(task: TaskService.shared.getTask(index: indexPath.row))
//        return cell
    }
}
