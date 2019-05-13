//
//  InterfaceController.swift
//  Calculator WatchKit Extension
//
//  Created by Jacob Gantt on 5/12/19.
//  Copyright © 2019 LemurWare LLC. All rights reserved.
//

import WatchKit
import Foundation
import os.log

class NumberInputInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var valueDisplay: WKInterfaceLabel!
    
    enum NegativeEqualsButtonState{
        case plusMinus
        case equals
    }
    var negativeEqualsButtonState: NegativeEqualsButtonState = .plusMinus
    
    enum DecimalState{
        case leftOfDecimal
        case rightOfDecimalInt
        case rightOfDecimalDouble
    }
    var decimalState: DecimalState = .leftOfDecimal
    
    var value: Double = 0{
        didSet{
            let newLabel = String(format: "%.\(decimalPlaces)f", value)
            valueDisplay.setText(newLabel)
            let toAnnounce: AnnouncementContentValueUpdate = (value, newLabel)
            AnnouncementCenter.default.post(name: AnnouncementName.valueUpdate, object: self, userInfo: [0: toAnnounce])
        }
    }
    
    var decimalMultiplier: Double = 1
    var decimalPlaces: Int = 0
    
    override init(){
        super.init()
        AnnouncementCenter.default.addObserver(self, selector: #selector(self.receivedAnnouncement), name: AnnouncementName.functionAwaiting, object: nil)
    }
    
    @objc func receivedAnnouncement(announcement: Announcement){
        switch announcement.name{

        case AnnouncementName.functionAwaiting:
            break

        default:
            os_log("Received unrecognized Announcement", log: OSLog.default, type: .error)
            break
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func zeroButton() {
        numberButton(0)
    }
    @IBAction func oneButton() {
        numberButton(1)
    }
    @IBAction func twoButton() {
        numberButton(2)
    }
    @IBAction func threeButton() {
        numberButton(3)
    }
    @IBAction func fourButton() {
        numberButton(4)
    }
    @IBAction func fiveButton() {
        numberButton(5)
    }
    @IBAction func sixButton() {
        numberButton(6)
    }
    @IBAction func sevenButton() {
        numberButton(7)
    }
    @IBAction func eightButton() {
        numberButton(8)
    }
    @IBAction func nineButton() {
        numberButton(9)
    }
    
    private func numberButton(_ number: Double){
        switch decimalState {
            
        case .leftOfDecimal:
            let newValue = (value * 10) + number
            if(value >= Double(Int64.max/100)){
                value = 0
                valueDisplay.setText("E: Too large")
            }else{
                value = newValue
            }
            
        case .rightOfDecimalDouble: fallthrough
        case .rightOfDecimalInt:
            decimalMultiplier = decimalMultiplier * 0.1
            decimalPlaces += 1
            if(decimalMultiplier < 0.00000000001){
                value = 0
                valueDisplay.setText("E: Too specific")
            }else{
                let newValue = value + (number * decimalMultiplier)
                value = newValue
            }
            
        }
    }
    
    @IBAction func decimalButton() {
        switch decimalState {
        case .leftOfDecimal:
            decimalState = .rightOfDecimalInt
        case .rightOfDecimalInt:
            decimalState = .leftOfDecimal
        case .rightOfDecimalDouble:
            break
        }
    }
    
    @IBAction func acButton() {
        reset()
    }
    
    private func reset(){
        decimalMultiplier = 1
        decimalPlaces = 0
        decimalState = .leftOfDecimal
        value = 0
        
    }
}
