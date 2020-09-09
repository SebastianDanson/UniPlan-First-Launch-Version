//
//  RoutinesViewController.swift
//  UniPlan
//
//  Created by Student on 2020-07-12.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

/*
 * This VC displays all of the users routines and allows them to add new ones
 */

class RoutinesViewController: SwipeNoCompleteViewController {
    
    let realm = try! Realm()
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.reloadData()
    }
    
    //MARK: - Properties
    let topView = makeTopView(height: UIScreen.main.bounds.height/9)
    let titleLabel = makeTitleLabel(withText: "Routines")
    let tableView = UITableView()
    let addButton = makeCornerAddButton()
    
    //MARK: - UI setup
    func setupViews() {
        tableView.isScrollEnabled = true
        tableView.separatorColor = .clear
        tableView.rowHeight = 120
        tableView.backgroundColor = .backgroundColor
        
        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        view.addSubview(tableView)
        view.addSubview(addButton)
        
        topView.addSubview(titleLabel)
        
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        titleLabel.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.centerX(in: topView)
        
        addButton.anchor(right: view.rightAnchor,
                         bottom: view.bottomAnchor,
                         paddingRight: 10,
                         paddingBottom: self.tabBarHeight + 10)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
        tableView.centerX(in: view)
        tableView.anchor(top: topView.bottomAnchor, paddingTop: 5)
        tableView.setDimensions(width: view.frame.width,
                                height: view.frame.height - topView.frame.height - (2 * self.tabBarHeight))
        tableView.register(SingleClassCell.self, forCellReuseIdentifier: courseReuseIdentifer)
        tableView.delegate = self
        tableView.dataSource = self
    }
    //What happens when user tries to delete course
    override func updateModel(index: Int, section: Int) {
        do {
            try realm.write {
                if let routineToDelete = RoutineService.shared.getRoutine(atIndex: index) {
                    TaskService.shared.deleteTasks(forRoutine: routineToDelete)
                    realm.delete(routineToDelete)
                    RoutineService.shared.updateRoutines()
                }
                tableView.reloadData()
            }
        } catch {
            print("Error deleting routine from Realm, \(error.localizedDescription)")
        }
    }
    
    //MARK: - Actions
    @objc func addButtonPressed() {
        RoutineService.shared.setIsRoutine(bool: true)
        RoutineService.shared.setSelectedRoutine(routine: nil)
        TaskService.shared.setIsClass(bool: true)
        let vc = AddClassViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

//MARK: - Tableview Delegate and Datasource
extension RoutinesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if RoutineService.shared.getRoutines()?.count == 0 {
            
            //If the user has no events for that Day it says so
            let noRoutinesLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 150))
            noRoutinesLabel.text = "No Routines Added"
            noRoutinesLabel.textColor = UIColor.darkBlue
            noRoutinesLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            noRoutinesLabel.textAlignment = .center
            tableView.tableHeaderView = noRoutinesLabel
            tableView.separatorStyle  = .none
            return 0
        }
        tableView.tableHeaderView = nil
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoutineService.shared.getRoutines()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: courseReuseIdentifer) as! SingleClassCell
        if let routine = RoutineService.shared.getRoutine(atIndex: indexPath.row) {
            cell.update(routine: routine)
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        RoutineService.shared.setIsRoutine(bool: true)
        RoutineService.shared.setRoutineIndex(index: indexPath.row)
        
        let vc = AddClassViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}


