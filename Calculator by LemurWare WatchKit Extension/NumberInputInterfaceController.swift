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
    enum State{
        case xValueNoDeimcals
        case xValueAwaitingDecimals
        case xValueWithDecimals
        case yValueDisplayingX (xValue: Double, math: Function)
        case yValueNoDeimcals (xValue: Double, math: Function)
        case yValueAwaitingDecimals (xValue: Double, math: Function)
        case yValueWithDecimals (xValue: Double, math: Function)
        case displayingResult (result: Double)
    }

    
    @IBOutlet weak var valueDisplay: WKInterfaceLabel!
    @IBOutlet weak var acButtonLabel: WKInterfaceButton!
    
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
    
    var decimalMultiplier: Double = 1
    var decimalPlaces: Int = 0
    
    var state: State = .xValueNoDeimcals
    
    override init(){
        super.init()
        
        AnnouncementCenter.default.addObserver(self, selector: #selector(self.receivedAnnouncement), name: AnnouncementName.functionAwaiting, object: nil)
    }
    
    @objc func receivedAnnouncement(announcement: Announcement){
        switch announcement.name{

        case AnnouncementName.functionAwaiting:
            becomeCurrentPage()
            guard let announcementMath = announcement.userInfo?[0] as? AnnouncementContentFunctionAwaiting else{
                os_log("Received unrecognized Announcement", log: OSLog.default, type: .error)
                return
            }
            switch announcementMath{
            case .tip:
                reset()
            default:
                switch state{
                    
                case .xValueNoDeimcals: fallthrough
                case .xValueAwaitingDecimals: fallthrough
                case .xValueWithDecimals:
                    tryOneVariable(math: announcementMath)
                    
                case .yValueDisplayingX(let xValue, _):
                    state = .yValueDisplayingX(xValue: xValue, math: announcementMath)
                    
                case .yValueNoDeimcals(let xValue, let math): fallthrough
                case .yValueAwaitingDecimals(let xValue, let math): fallthrough
                case .yValueWithDecimals(let xValue, let math):
                    doTwoVaraible(xValue: xValue, math: math)
                    tryOneVariable(math: announcementMath)
                    
                case .displayingResult:
                    tryOneVariable(math: announcementMath)
                }
            }

        default:
            os_log("Received unrecognized Announcement", log: OSLog.default, type: .error)
        }
    }
    
    @objc func goToSettings(){
        presentController(withName: "Settings", context: nil)
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        addMenuItem(with: .more, title: "Credits", action: #selector(self.goToSettings))
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
        switch state {
            
        case .displayingResult:
            reset()
            addLeftOfDecimal(number)
            
        case .yValueDisplayingX(let xValue, let math):
            acButtonLabel.setTitle("=")
            state = .yValueNoDeimcals(xValue: xValue, math: math)
            addLeftOfDecimal(number)
            
        case .xValueNoDeimcals: fallthrough
        case .yValueNoDeimcals:
            addLeftOfDecimal(number)
            
        case .xValueAwaitingDecimals:
            state = .xValueWithDecimals
            addRightOfDecfimal(number)
            
        case .yValueAwaitingDecimals(let xValue, let math):
            state = . yValueWithDecimals(xValue: xValue, math: math)
            addRightOfDecfimal(number)
        
        case .xValueWithDecimals: fallthrough
        case .yValueWithDecimals:
            addRightOfDecfimal(number)
            
        }
    }
    
    private func addLeftOfDecimal(_ number: Double){
        let newValue = (valueLabel.v * 10) + number
        if(valueLabel.v >= Double(Int64.max/100)){
            valueLabel = ValueLabel(0)
            valueDisplay.setText("E: Too large")
        }else{
            valueLabel = ValueLabel(newValue)
        }
    }
    
    private func addRightOfDecfimal(_ number: Double){
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
    
    @IBAction func decimalButton() {
        switch state {
        case .xValueNoDeimcals:
            state = .xValueAwaitingDecimals
        case .yValueNoDeimcals(let xValue, let math):
            state = .yValueAwaitingDecimals(xValue: xValue, math: math)
        case .xValueAwaitingDecimals: fallthrough
        case .xValueWithDecimals: fallthrough
        case .yValueAwaitingDecimals: fallthrough
        case .yValueWithDecimals:
            break
        case .displayingResult:
            reset()
            state = .xValueNoDeimcals
        case .yValueDisplayingX(let xValue, let math):
            reset()
            acButtonLabel.setTitle("=")
            state = .yValueAwaitingDecimals(xValue: xValue, math: math)
        }
    }
    
    @IBAction func acButton() {
        switch state {
        case .xValueNoDeimcals: fallthrough
        case .xValueAwaitingDecimals: fallthrough
        case .xValueWithDecimals: fallthrough
        case .yValueDisplayingX: fallthrough
        case .displayingResult:
            reset()
        case .yValueNoDeimcals(let xValue, let math): fallthrough
        case .yValueAwaitingDecimals(let xValue, let math): fallthrough
        case .yValueWithDecimals(let xValue, let math):
            doTwoVaraible(xValue: xValue, math: math)
        }
    }
    
    private func tryOneVariable(math: Function){
        let result = MathDoer.tryWithX(math, xValue: valueLabel.v)
        if let toDisplay = result{
            reset()
            valueLabel = ValueLabel(0.0, label: toStringWithOwnDecimalPlaces(toDisplay))
        }else{
            let labelTemp = valueLabel.label
            reset()
            state = .yValueDisplayingX(xValue: valueLabel.v, math: math)
            valueLabel = ValueLabel(0.0, label: labelTemp)
        }
        
    }
    
    private func doTwoVaraible(xValue: Double, math: Function){
        let result = MathDoer.tryWithXAndY(math, xValue: xValue, yValue: valueLabel.v)
        reset()
        valueLabel = ValueLabel(result, label: toStringWithOwnDecimalPlaces(result))
    }
    
    private func reset(){
        valueLabel = ValueLabel(0)
        decimalMultiplier = 1
        decimalPlaces = 0
        state = .xValueNoDeimcals
        acButtonLabel.setTitle("AC")
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
