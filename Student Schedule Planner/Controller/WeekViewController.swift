//
//  WeekViewController.swift
//  UniPlan
//
//  Created by Student on 2020-07-15.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift

/*
 * This VC displays a week view for the users events
 */

class WeekViewController: UIViewController {
    
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
    let topView = makeTopView(height: UIScreen.main.bounds.height/15)
    let titleLabel = makeLabel(ofSize: 24, weight: .bold)
    var tableView = UITableView()
    let addButton = UIButton()
    var leftTableView = UITableView()
    var rightTableView = UITableView()
    
    //MARK: - UI setup
    func setupViews() {
        tableView.isScrollEnabled = true
        tableView.rowHeight = UIScreen.main.bounds.height/9.55 + 13
        tableView.backgroundColor = .backgroundColor
        
        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        view.addSubview(tableView)
        view.addSubview(leftTableView)
        view.addSubview(rightTableView)
        
        
        topView.addSubview(titleLabel)
        topView.addSubview(addButton)
        
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        titleLabel.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.anchor(left: topView.leftAnchor, paddingLeft: 40)
        titleLabel.text =  "\(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek())) - \(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(7*86400)))"
        titleLabel.textColor = .white
        
        addButton.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        addButton.anchor(right: topView.rightAnchor, paddingRight: 10)
        addButton.backgroundColor = .clear
        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 50, weight: .regular)
        addButton.setDimensions(width: UIScreen.main.bounds.height/10, height: UIScreen.main.bounds.height/10)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
        tableView.centerX(in: view)
        tableView.anchor(top: topView.bottomAnchor, paddingTop: 1)
        tableView.setDimensions(width: view.frame.width,
                                height: view.frame.height - topView.frame.height)
        tableView.register(WeekCell.self, forCellReuseIdentifier: "Week")
        tableView.delegate = self
        tableView.dataSource = self
        
        let panGesture = UIPanGestureRecognizer(target: self, action:(#selector(self.handleGesture)))
        let topViewPanGesture = UIPanGestureRecognizer(target: self, action:(#selector(self.handleGesture)))
        tableView.addGestureRecognizer(panGesture)
        
        rightTableView.register(WeekCell.self, forCellReuseIdentifier: "Right")
        rightTableView.delegate = self
        rightTableView.dataSource = self
        rightTableView.rowHeight = UIScreen.main.bounds.height/9.55 + 13
        rightTableView.anchor(top: tableView.topAnchor, left: tableView.rightAnchor)
        rightTableView.setDimensions(width: view.frame.width,
                                     height: view.frame.height - topView.frame.height)
        
        leftTableView.register(WeekCell.self, forCellReuseIdentifier: "Left")
        leftTableView.delegate = self
        leftTableView.dataSource = self
        leftTableView.rowHeight = UIScreen.main.bounds.height/9.55 + 13
        leftTableView.anchor(top: tableView.topAnchor, right: tableView.leftAnchor)
        leftTableView.setDimensions(width: view.frame.width,
                                    height: view.frame.height - topView.frame.height)
    }
    
    //MARK: - Actions
    @objc func handleGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        
        switch sender.state {
        case .began:
            self.LeftTableViewSwipe()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.02, execute: {
                self.RightTableViewSwipe()
                
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                TaskService.shared.setfirstDayOfWeek(date: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(-7*86400))
            })
        case .changed:
            tableView.transform = CGAffineTransform(translationX: translation.x, y: 0)
            leftTableView.transform = CGAffineTransform(translationX: translation.x, y: 0)
            rightTableView.transform = CGAffineTransform(translationX: translation.x, y: 0)
        case .ended:
            if translation.x >= UIScreen.main.bounds.width/2.25 {
                
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: .curveEaseIn, animations: {
                    self.tableView.transform = self.tableView.transform.translatedBy(x:  -(translation.x - UIScreen.main.bounds.width), y: 0)
                    self.leftTableView.transform = self.leftTableView.transform.translatedBy(x: -(translation.x - UIScreen.main.bounds.width), y: 0)
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: {
                    
                    self.TableViewSwipeRight()
                })
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                    self.tableView.transform = .identity
                    self.leftTableView.transform = .identity
                    self.rightTableView.transform = .identity
                })
                
                
                
            } else if translation.x <= -UIScreen.main.bounds.width/2.25 {
                
                
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: .curveEaseIn, animations: {
                    
                    self.tableView.transform = self.tableView.transform.translatedBy(x:  -translation.x - UIScreen.main.bounds.width, y: 0)
                    self.rightTableView.transform = self.rightTableView.transform.translatedBy(x:  -translation.x - UIScreen.main.bounds.width, y: 0)
                    
                    
                    
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: {
                    self.TableViewSwipeLeft()
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                    self.tableView.transform = .identity
                    self.leftTableView.transform = .identity
                    self.rightTableView.transform = .identity
                })
                
                titleLabel.text = "\(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek())) - \(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(6*86400)))"
            } else {
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: .curveEaseIn, animations: {
                    self.leftTableView.transform = .identity
                    self.tableView.transform = .identity
                    self.rightTableView.transform = .identity
                })
            }
        default:
            break
        }
    }
    @objc func TableViewSwipeLeft() {
        TaskService.shared.setfirstDayOfWeek(date: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(7*86400))
        tableView.reloadData()
        titleLabel.text = "\(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek())) - \(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(6*86400)))"
    }
    
    @objc func LeftTableViewSwipe() {
        TaskService.shared.setfirstDayOfWeek(date: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(-7*86400))
        leftTableView.reloadData()
    }
    
    @objc func RightTableViewSwipe() {
        TaskService.shared.setfirstDayOfWeek(date: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(2*7*86400))
        rightTableView.reloadData()
    }
    
    @objc func TableViewSwipeRight() {
        TaskService.shared.setfirstDayOfWeek(date: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(-7*86400))
        tableView.reloadData()
        titleLabel.text = "\(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek())) - \(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(6*86400)))"
    }
    
    @objc func addButtonPressed() {
        TaskService.shared.setDateOrTime(scIndex: 0)
        TaskService.shared.setReminderDate(date: Date())
        TaskService.shared.setReminderTime([0,0])
        
        let vc = AddTaskViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK: - Tableview Delegate and Datasource
extension WeekViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let date = TaskService.shared.getfirstDayOfWeek()
        switch tableView {
        case rightTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Right") as! WeekCell
            switch indexPath.row {
            case 0:
                cell.update(date: date)
            case 1:
                cell.update(date: date.addingTimeInterval(1*86400))
            case 2:
                cell.update(date: date.addingTimeInterval(2*86400))
            case 3:
                cell.update(date: date.addingTimeInterval(3*86400))
            case 4:
                cell.update(date: date.addingTimeInterval(4*86400))
            case 5:
                cell.update(date: date.addingTimeInterval(5*86400))
            case 6:
                cell.update(date: date.addingTimeInterval(6*86400))
            default:
                break
            }
            return cell
        case leftTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Left") as! WeekCell
            switch indexPath.row {
            case 0:
                cell.update(date: date)
            case 1:
                cell.update(date: date.addingTimeInterval(1*86400))
            case 2:
                cell.update(date: date.addingTimeInterval(2*86400))
            case 3:
                cell.update(date: date.addingTimeInterval(3*86400))
            case 4:
                cell.update(date: date.addingTimeInterval(4*86400))
            case 5:
                cell.update(date: date.addingTimeInterval(5*86400))
            case 6:
                cell.update(date: date.addingTimeInterval(6*86400))
            default:
                break
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Week") as! WeekCell
            switch indexPath.row {
            case 0:
                cell.update(date: date)
            case 1:
                cell.update(date: date.addingTimeInterval(1*86400))
            case 2:
                cell.update(date: date.addingTimeInterval(2*86400))
            case 3:
                cell.update(date: date.addingTimeInterval(3*86400))
            case 4:
                cell.update(date: date.addingTimeInterval(4*86400))
            case 5:
                cell.update(date: date.addingTimeInterval(5*86400))
            case 6:
                cell.update(date: date.addingTimeInterval(6*86400))
            default:
                break
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

