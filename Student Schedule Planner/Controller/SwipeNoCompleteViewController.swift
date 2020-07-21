//
//  SwipeNoCompleteViewController.swift
//  UniPlan
//
//  Created by Student on 2020-07-12.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import SwipeCellKit

/*
 * Allows cells to be swipeable only to the right
 */
class SwipeNoCompleteViewController: UIViewController, SwipeTableViewCellDelegate {
    
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
        } else {return nil}
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        
        if orientation == .right {
            options.expansionStyle = .destructive(automaticallyDelete: false)
        } 
        return options
        
    }
    
    //What happens when a cell is swiped on
    //All VCs that inherit this one override this method
    func updateModel(index: Int, section: Int) {}
    func complete(index: Int, section: Int) {}
    
}


