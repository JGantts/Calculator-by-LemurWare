//
//  TrigFunctionsInterfaceController.swift
//  Calculator WatchKit Extension
//
//  Created by Jacob Gantt on 5/12/19.
//  Copyright © 2019 LemurWare LLC. All rights reserved.
//

import WatchKit
import Foundation
import os.log

class TrigFunctionsInterfaceController: WKInterfaceController {

    @IBOutlet weak var valueLabel: WKInterfaceLabel!
    @IBOutlet weak var radDedButtonLabel: WKInterfaceButton!
    
    var value: Decimal = 0
    var radDeg: RadDeg = .deg {
        didSet{
            switch radDeg {
            case .rad:
                radDedButtonLabel.setTitle("Rad")
            case .deg:
                radDedButtonLabel.setTitle("Deg")
            }
        }
    }
    
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
            value = content.value
            valueLabel.setText(content.label)
            
        default:
            os_log("Received unrecognized Announcement", log: OSLog.default, type: .error)
            break
        }
    }
    
    @objc func goToSettings(){
        presentController(withName: "Settings", context: nil)
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        addMenuItem(with: .more, title: "Credits", action: #selector(self.goToSettings))
    }

    @IBAction func radDegButton() {
        switch radDeg {
        case .rad:
            radDeg = .deg
        case .deg:
            radDeg = .rad
        }
    }
    
    @IBAction func tanButton() {
        announce(.tan(radDeg))
    }
    @IBAction func sinButton() {
        announce(.sin(radDeg))
    }
    @IBAction func cosButton() {
        announce(.cos(radDeg))
    }
    @IBAction func yRootXButton() {
        announce(.toTheYthRoot)
    }
    @IBAction func xTotheY() {
        announce(.toThePowerOfY)
    }
    
    
    private func announce(_ toAnnounce: AnnouncementContentFunctionAwaiting){
        AnnouncementCenter.default.post(name: AnnouncementName.functionAwaiting, object: self, userInfo: [0: toAnnounce])
    }
}
