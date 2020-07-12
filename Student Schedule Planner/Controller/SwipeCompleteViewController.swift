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
class SwipeCompleteViewController: UIViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Swipe Cell Delegate Methods
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .right {
            
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.updateModel(index: indexPath.row, section: indexPath.section)
        }
        deleteAction.image = UIImage(named: "Trash")
        
        return [deleteAction]
        } else if orientation == .left {
            let completeAction = SwipeAction(style: .default, title: "Complete") { action, indexPath in
                self.complete(index: indexPath.row, section: indexPath.section)

            }
            completeAction.image = UIImage(systemName: "checkmark.circle.fill")
            completeAction.backgroundColor = .emerald
            return [completeAction]
        } else {return nil}
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        
        if orientation == .right {
        options.expansionStyle = .destructive(automaticallyDelete: false)
        } else if orientation == .left {
            var selectionShort: SwipeExpansionStyle { return SwipeExpansionStyle(target: .percentage(0.1),
            elasticOverscroll: true,
            completionAnimation: .bounce) }
            options.expansionStyle = selectionShort
        }
        return options
            
    }
    
    //What happens when a cell is swiped on
    //All VCs that inherit this one override this method
    func updateModel(index: Int, section: Int) {}
    func complete(index: Int, section: Int) {}

}


