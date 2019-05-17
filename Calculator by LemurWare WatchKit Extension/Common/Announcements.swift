//
//  Notifications.swift
//  MultiTimer WatchKit Extension
//
//  Created by Jacob Gantt on 2/25/19.
//  Copyright © 2019 Jacob Gantt. All rights reserved.
//

import Foundation

typealias AnnouncementCenter = NotificationCenter
typealias Announcement = NSNotification

typealias AnnouncementContentValueUpdate = (value: Decimal, label: String)
typealias AnnouncementContentFunctionAwaiting = Function

enum AnnouncementName{
    static let valueUpdate: NSNotification.Name = NSNotification.Name(rawValue: "LemurWare_Calculator_valueUpdate")
    static let functionAwaiting: NSNotification.Name = NSNotification.Name(rawValue: "LemurWare_Calculator_functionAwaiting")
}
