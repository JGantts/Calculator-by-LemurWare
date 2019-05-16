//
//  Functions.swift
//  Calculator WatchKit Extension
//
//  Created by Jacob Gantt on 5/12/19.
//  Copyright © 2019 LemurWare LLC. All rights reserved.
//

import Foundation

enum RadDeg{
    case rad
    case deg
}

enum Function{
    case plus
    case minus
    case multiply
    case divide
    case percent
    case tip
    case toTheYthRoot
    case toThePowerOfY
    case sin(RadDeg)
    case cos(RadDeg)
    case tan(RadDeg)
}
