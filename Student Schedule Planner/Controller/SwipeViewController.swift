//
//  SwipeTableViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-11.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//



import UIKit
import SwipeCellKit

/*
 * Allows cells to be swipeable
 */
class SwipeViewController: UIViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Swipe Cell Delegate Methods
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.updateModel(index: indexPath.row, section: indexPath.section)
        }
        deleteAction.image = UIImage(named: "Trash")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive(automaticallyDelete: false)
        return options
    }
    
    //What happens when a cell is swiped on
    //All VCs that inherit this one override this method
    func updateModel(index: Int, section: Int) {}
}


