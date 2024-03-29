//
//  WeekTableTableViewController.swift
//  UniPlan
//
//  Created by Student on 2020-08-07.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit

class AfterWeekViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.tableView.register(WeekCell.self, forCellReuseIdentifier: "Week")

        self.tableView.frame = CGRect(x:0, y: UIScreen.main.bounds.height/10, width: view.frame.width, height: view.frame.height - UIScreen.main.bounds.height/15)
        self.tableView.rowHeight = UIScreen.main.bounds.height/9.2 + 7.6
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "Week") as! WeekCell
        
        let date = TaskService.shared.getfirstDayOfWeek()
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
