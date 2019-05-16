//
//  ValueLabel.swift
//  Calculator WatchKit Extension
//
//  Created by Jacob Gantt on 5/12/19.
//  Copyright © 2019 LemurWare LLC. All rights reserved.
//

import Foundation

struct ValueLabel{
    let v: Double
    var label: String?
    
    init(_ value: Double, label: String? = nil){
        self.v = value
        self.label = label
    }
}
