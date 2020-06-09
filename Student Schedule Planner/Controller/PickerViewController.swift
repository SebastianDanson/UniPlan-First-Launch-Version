//
//  PickerViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-08.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var hour:Int = 0
    var minutes:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 25
        case 1, 4:
            return 1
        case 3:
            return 60
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0:
            return pickerView.frame.size.width/6
        case 1:
            return pickerView.frame.size.width/4
        case 2:
            return pickerView.frame.size.width/8
        case 3:
            return pickerView.frame.size.width/6
        case 4:
            return pickerView.frame.size.width/4
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row)"
        case 1:
            return "hours"
        case 3:
            return "\(row)"
        case 4:
            return "min"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:
            hour = row
        case 3:
            minutes = row
        default:
            break;
        }
    }
}
