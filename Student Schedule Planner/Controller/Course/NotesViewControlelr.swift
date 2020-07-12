//
//  NotesViewControlelr.swift
//  UniPlan
//
//  Created by Student on 2020-07-12.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

//
//  NotesViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-11.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

/*
 * This VC displays all of the users Notes
 */
class NotesViewController: SwipeNoCompleteViewController {
    
    let realm = try! Realm()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AllCoursesService.shared.setSelectedCourse(course: nil)
        tableView.reloadData()
    }
    
    //MARK: - Properties
    let topView = makeTopView(height: UIScreen.main.bounds.height/8.5)
    let titleLabel = makeTitleLabel(withText: "Notes")
    let addButton = makeAddButton()
    let tableView = UITableView()
    
    //MARK: - UI setup
    func setupViews() {
        tableView.isScrollEnabled = true
        tableView.separatorColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.backgroundColor = .backgroundColor
        
        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        view.addSubview(tableView)
        
        topView.addSubview(titleLabel)
        topView.addSubview(addButton)
        
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        titleLabel.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.centerX(in: topView)
        
        addButton.anchor(right: topView.rightAnchor, paddingRight: 20)
        addButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
        tableView.centerX(in: view)
        tableView.anchor(top: topView.bottomAnchor, paddingTop: 5)
        tableView.setDimensions(width: view.frame.width,
                                height: view.frame.height - topView.frame.height - (2 * self.tabBarHeight))
        tableView.register(NoteCell.self, forCellReuseIdentifier: courseReuseIdentifer)
        tableView.delegate = self
        tableView.dataSource = self
    }
    //What happens when user tries to delete a note
    override func updateModel(index: Int, section: Int) {
        do {
            try realm.write {
                if let note = CourseService.shared.getAllNotes(atIndex: index) {
                    realm.delete(note)
                }
            }
        } catch{
            print("Error deleting note from realm, \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Actions
    @objc func addButtonPressed() {
        CourseService.shared.setSelectedNote(note: nil)
        AllCoursesService.shared.setAddSummative(bool: true)
        AllCoursesService.shared.setAddNote(bool: true)
        let vc = CoursesViewController()
        present(vc, animated: true)
    }
}

//MARK: - Tableview Delegate and Datasource
extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if CourseService.shared.getAllNotes()?.count == 0 {
            
            //If the user has not added any notes it tells that user so
            let noNotesLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 100))
            noNotesLabel.text = "No Notes Added"
            noNotesLabel.textColor = UIColor.darkBlue
            noNotesLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            noNotesLabel.textAlignment = .center
            tableView.tableHeaderView = noNotesLabel
            tableView.separatorStyle = .none
            return 0
        }
        tableView.tableHeaderView = nil
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CourseService.shared.getAllNotes()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: courseReuseIdentifer) as! NoteCell
        if let note = CourseService.shared.getAllNotes(atIndex: indexPath.row) {
            cell.update(note: note)
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = CourseService.shared.getAllNotes(atIndex: indexPath.row)
        CourseService.shared.setSelectedNote(note: note)
        
        let vc = AddNotesViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}


