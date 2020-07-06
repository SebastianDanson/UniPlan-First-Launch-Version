//
//  HelperFunctions.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-21.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit

func getColor(colorAsInt color: Int) -> UIColor {
    
    switch color {
    case 0:
        return .alizarin
    case 1:
        return .carrot
    case 2:
       return .sunflower
    case 3:
        return .emerald
    case 4:
        return .turquoise
    case 5:
        return .riverBlue
    case 6:
       return  .midnightBlue
    case 7:
        return .amethyst
    default:
        return .clear
    }
}
