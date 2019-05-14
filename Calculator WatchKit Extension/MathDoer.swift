//
//  MathDoer.swift
//  Calculator WatchKit Extension
//
//  Created by Jacob Gantt on 5/12/19.
//  Copyright © 2019 LemurWare LLC. All rights reserved.
//

import Foundation

class MathDoer{
    
    static func tryWithX(_ math: Function, xValue: Double) -> Double?{
        switch math{
            
        case .plus: fallthrough
        case .minus: fallthrough
        case .multiply: fallthrough
        case .divide: fallthrough
        case .toTheYthRoot: fallthrough
        case .toThePowerOfY: fallthrough
        case .percent:
            return nil
            
        case .sin(let radDeg):
            switch radDeg{
            case .rad:
                return sin(xValue * Double.pi / 180)
            case .deg:
                return sin(xValue * Double.pi / 180)
            }
            
        case .cos(let radDeg):
            switch radDeg{
            case .rad:
                return cos(xValue * Double.pi / 180)
            case .deg:
                return cos(xValue * Double.pi / 180)
            }
            
        case .tan(let radDeg):
            switch radDeg{
            case .rad:
                return tan(xValue * Double.pi / 180)
            case .deg:
                return tan(xValue * Double.pi / 180)
            }
            
        case .tip:
            assert(false)
            return 0
        }
    }
    
    static func tryWithXAndY(_ math: Function, xValue: Double, yValue: Double) -> Double{
        switch math{
            
        case .plus:
            return xValue + yValue
            
        case .minus:
            return xValue - yValue
            
        case .multiply:
            return xValue * yValue
            
        case .divide:
            if (yValue == 0.0){
                return 0.0
            }else{
                return xValue / yValue
            }
            
        case .toTheYthRoot:
            return pow(xValue, 1.0/yValue)
            
        case .toThePowerOfY:
            return pow(xValue, yValue)
            
        case .percent:
            return xValue * yValue / 100.0
            
        case .sin:      fallthrough
        case .cos:      fallthrough
        case .tan:      fallthrough
        case .tip:
            assert(false)
            return 0.0
        }
    }
}
