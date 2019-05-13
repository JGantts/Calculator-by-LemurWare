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
    enum DecimalState{
        case leftOfDecimal
        case rightOfDecimalAwaitingDecimals
        case rightOfDecimal
    }
    enum AcEqualsState{
        case enteringX
        case enteringY(Function)
    }
    
    @IBOutlet weak var valueDisplay: WKInterfaceLabel!
    @IBOutlet weak var acButtonLabel: WKInterfaceButton!
    
    var decimalState: DecimalState = .leftOfDecimal
    
    var valueLabel: ValueLabel = ValueLabel(0){
        didSet{
            
            let newLabel: String
            if let temp = valueLabel.label{
                newLabel = temp
            }else{
                newLabel = toStringWithForcedDecimalPlaces(valueLabel.v)
                valueLabel = ValueLabel(valueLabel.v, label: newLabel)
            }
            valueDisplay.setText(newLabel)
            let toAnnounce: AnnouncementContentValueUpdate = (valueLabel.v, newLabel)
            AnnouncementCenter.default.post(name: AnnouncementName.valueUpdate, object: self, userInfo: [0: toAnnounce])
        }
    }
    var xValue: Double? = nil
    
    var decimalMultiplier: Double = 1
    var decimalPlaces: Int = 0
    
    var acEqualsState: AcEqualsState = .enteringX
    
    override init(){
        super.init()
        
        AnnouncementCenter.default.addObserver(self, selector: #selector(self.receivedAnnouncement), name: AnnouncementName.functionAwaiting, object: nil)
    }
    
    @objc func receivedAnnouncement(announcement: Announcement){
        switch announcement.name{

        case AnnouncementName.functionAwaiting:
            becomeCurrentPage()
            guard let content = announcement.userInfo?[0] as? AnnouncementContentFunctionAwaiting else{
                os_log("Received unrecognized Announcement", log: OSLog.default, type: .error)
                return
            }
            switch content{
            case .tip:
                reset()
            default:
                let result = MathDoer.tryWithX(content, xValue: valueLabel.v)
                if let toDisplay = result{
                    reset()
                    valueLabel = ValueLabel(0.0, label: toStringWithOwnDecimalPlaces(toDisplay))
                }else{
                    xValue = valueLabel.v
                    let labelTemp = valueLabel.label
                    reset()
                    acButtonLabel.setTitle("=")
                    acEqualsState = .enteringY(content)
                    valueLabel = ValueLabel(0.0, label: labelTemp)
                }
            }

        default:
            os_log("Received unrecognized Announcement", log: OSLog.default, type: .error)
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
            let newValue = (valueLabel.v * 10) + number
            if(valueLabel.v >= Double(Int64.max/100)){
                valueLabel = ValueLabel(0)
                valueDisplay.setText("E: Too large")
            }else{
                valueLabel = ValueLabel(newValue)
            }
            
        case .rightOfDecimalAwaitingDecimals: fallthrough
        case .rightOfDecimal:
            decimalMultiplier = decimalMultiplier * 0.1
            decimalPlaces += 1
            if(decimalMultiplier < 0.00000000001){
                valueLabel = ValueLabel(0)
                valueDisplay.setText("E: Too specific")
            }else{
                let newValue = valueLabel.v + (number * decimalMultiplier)
                valueLabel = ValueLabel(newValue)
            }
            
        }
    }
    
    @IBAction func decimalButton() {
        switch decimalState {
        case .leftOfDecimal:
            decimalState = .rightOfDecimalAwaitingDecimals
        case .rightOfDecimalAwaitingDecimals: fallthrough
        case .rightOfDecimal:
            break
        }
    }
    
    @IBAction func acButton() {
        switch acEqualsState{
            
        case .enteringX:
                reset()
        case .enteringY(let math):
            guard let xValue = xValue else{
                assert(false)
                return
            }
            let result = MathDoer.tryWithXAndY(math, xValue: xValue, yValue: valueLabel.v)
            reset()
            valueLabel = ValueLabel(result, label: toStringWithOwnDecimalPlaces(result))
        }
    }
    
    private func reset(){
        decimalMultiplier = 1
        decimalPlaces = 0
        decimalState = .leftOfDecimal
        valueLabel = ValueLabel(0)
        acButtonLabel.setTitle("AC")
        acEqualsState = .enteringX
    }
    
    private func toStringWithForcedDecimalPlaces(_ numb: Double, places placesIn: Int? = nil) -> String{
        let places: Int = placesIn ?? self.decimalPlaces
        return String(format: "%.\(places)f", numb)
    }
    
    private func toStringWithOwnDecimalPlaces(_ numb: Double) -> String{
        if
            numb < 00.0000000000001 &&
            numb > -0.0000000000001
        {
            return "0"
        }
        return(NSDecimalNumber(decimal: Decimal(numb)).stringValue)
    }
}
