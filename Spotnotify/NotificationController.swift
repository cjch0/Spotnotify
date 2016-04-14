//
//  NotificationController.swift
//  Spotnotify
//
//  Created by Chris Cho on 4/12/16.
//  Copyright © 2016 Chris Cho. All rights reserved.
//

import Cocoa

class NotificationController: NSObject, NSUserNotificationCenterDelegate {
    
    func notify(trackName: String, artistName: String, albumName: String, albumArt: NSImage?) {
        let notification:NSUserNotification = NSUserNotification()
        notification.title = trackName
        notification.subtitle = artistName + " - " + albumName
//        notification.contentImage = albumArt
        
        // private
        notification.setValue(albumArt, forKey: "_identityImage")
        notification.setValue(false, forKey: "_identityImageHasBorder")
        
        NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
    }
    
    func userNotificationCenter(center: NSUserNotificationCenter, didActivateNotification notification: NSUserNotification) {
        NSWorkspace.sharedWorkspace().launchApplication("Spotify")
    }
}