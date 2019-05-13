//
//  BasicFunctionInterfaceController.swift
//  Calculator WatchKit Extension
//
//  Created by Jacob Gantt on 5/12/19.
//  Copyright © 2019 LemurWare LLC. All rights reserved.
//

import WatchKit
import Foundation
import os.log

class BasicFunctionInterfaceController: WKInterfaceController {

    @IBOutlet weak var valueLabelDisplay: WKInterfaceLabel!
    
    var value: Double = 0
    var valueLabel = ValueLabel(0)
    
    override init(){
        super.init()
        AnnouncementCenter.default.addObserver(self, selector: #selector(self.receivedAnnouncement), name: AnnouncementName.valueUpdate, object: nil)
    }
    
    @objc func receivedAnnouncement(announcement: Announcement){
        switch announcement.name{
            
        case AnnouncementName.valueUpdate:
            guard let content = announcement.userInfo?[0] as? AnnouncementContentValueUpdate else{
                os_log("Received unrecognized Announcement", log: OSLog.default, type: .error)
                return
            }
            self.valueLabel = ValueLabel(content.value, label: content.label)
            value = content.value
            valueLabelDisplay.setText(content.label)
            
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

    @IBAction func plusButton() {
        announce(.plus)
    }
    @IBAction func minusButton() {
        announce(.minus)
    }
    @IBAction func multiplyButton() {
        announce(.multiply)
    }
    @IBAction func dividedByButton() {
        announce(.divide)
    }
    @IBAction func percentButton() {
        announce(.percent)
    }
    @IBAction func tipButton() {
        presentController(withName: "TipFunction", context: valueLabel)
        announce(.tip)
    }
    
    private func announce(_ toAnnounce: AnnouncementContentFunctionAwaiting){
        AnnouncementCenter.default.post(name: AnnouncementName.functionAwaiting, object: self, userInfo: [0: toAnnounce])
    }
    
}
