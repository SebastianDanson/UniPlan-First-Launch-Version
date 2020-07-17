//
//  FrequencyPickerViewController.swift
//  UniPlan
//
//  Created by Student on 2020-07-16.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit

/*
 * Creates a cutom picker view with days, weekdays, and weeks
 */

class FrequencyPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 31
        default:
            return 3
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0:
            return pickerView.frame.size.width/3
        default:
            return pickerView.frame.size.width/3
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(row)"
        }else {
            switch row {
            case 0:
                return "Week"
            case 1:
                return "Day"
            default:
                return "Weekday"
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            TaskService.shared.setFrequencyNum(frequency: row)
        } else if component == 1 {
            TaskService.shared.setFrequencyLenth(length: row)
        }
        updateLabel()
    }
    
    func updateLabel() {}
}
