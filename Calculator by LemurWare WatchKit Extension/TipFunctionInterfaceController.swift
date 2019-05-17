//
//  TipFunctionInterfaceController.swift
//  Calculator WatchKit Extension
//
//  Created by Jacob Gantt on 5/13/19.
//  Copyright © 2019 LemurWare LLC. All rights reserved.
//

import WatchKit
import Foundation


class TipFunctionInterfaceController: WKInterfaceController {

    @IBOutlet weak var value: WKInterfaceLabel!
    
    @IBOutlet weak var five_tip: WKInterfaceLabel!
    @IBOutlet weak var five_total: WKInterfaceLabel!
    @IBOutlet weak var ten_tip: WKInterfaceLabel!
    @IBOutlet weak var ten_total: WKInterfaceLabel!
    @IBOutlet weak var fifteen_tip: WKInterfaceLabel!
    @IBOutlet weak var fifteen_total: WKInterfaceLabel!
    @IBOutlet weak var twenty_tip: WKInterfaceLabel!
    @IBOutlet weak var twenty_total: WKInterfaceLabel!
    @IBOutlet weak var twentyfive_tip: WKInterfaceLabel!
    @IBOutlet weak var twentyfive_total: WKInterfaceLabel!
    @IBOutlet weak var thirty_tip: WKInterfaceLabel!
    @IBOutlet weak var thirty_total: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        guard let valueLabel = context as? ValueLabel else{
            assert(false)
            return
        }
        value.setText(toString(valueLabel.v))
        five_tip.setText(toString(valueLabel.v * 0.05))
        five_total.setText(toString(valueLabel.v * 1.05))
        ten_tip.setText(toString(valueLabel.v * 0.1))
        ten_total.setText(toString(valueLabel.v * 1.1))
        fifteen_tip.setText(toString(valueLabel.v * 0.15))
        fifteen_total.setText(toString(valueLabel.v * 1.15))
        twenty_tip.setText(toString(valueLabel.v * 0.2))
        twenty_total.setText(toString(valueLabel.v * 1.2))
        twentyfive_tip.setText(toString(valueLabel.v * 0.25))
        twentyfive_total.setText(toString(valueLabel.v * 1.25))
        thirty_tip.setText(toString(valueLabel.v * 0.3))
        thirty_total.setText(toString(valueLabel.v * 1.3))
        
        
        // Configure interface objects here.
    }
    
    private func toString(_ numb: Decimal) -> String{
        return String(format: "$%.2f", NSDecimalNumber(decimal: numb).doubleValue)
    }

}
