//
//  InitializerInterfaceController.swift
//  Calculator WatchKit Extension
//
//  Created by Jacob Gantt on 5/13/19.
//  Copyright © 2019 LemurWare LLC. All rights reserved.
//

import WatchKit
import Foundation


class InitializerInterfaceController: WKInterfaceController {
    
    override init(){
        super.init()
    }
    
    override func awake(withContext context: Any?) {
        WKInterfaceController.reloadRootPageControllers(
            withNames: ["TrigFunctions", "NumberInput", "BasicFunctions"],
            contexts: nil,
            orientation: .horizontal,
            pageIndex: 1)
    }
}
