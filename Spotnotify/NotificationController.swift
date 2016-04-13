//
//  NotificationController.swift
//  Spotnotify
//
//  Created by Chris Cho on 4/12/16.
//  Copyright © 2016 Chris Cho. All rights reserved.
//

import Cocoa

class NotificationController: NSObject, NSUserNotificationCenterDelegate {
    
    func notify(title: String, subtitle: String, informativeText: String, contentImage: NSImage?) {
        let notification:NSUserNotification = NSUserNotification()
        notification.title = title
        notification.subtitle = subtitle
        notification.informativeText = informativeText
        notification.contentImage = contentImage

        NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
    }
    
    func userNotificationCenter(center: NSUserNotificationCenter, didActivateNotification notification: NSUserNotification) {
        NSWorkspace.sharedWorkspace().launchApplication("Spotify")
    }
}