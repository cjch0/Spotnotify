//
//  AppDelegate.swift
//  Spotnotify
//
//  Created by Chris Cho on 4/9/16.
//  Copyright © 2016 Chris Cho. All rights reserved.
//

import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
   
   let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
   
   let userPreferenceMap: [String: String] = [
      "Notification Sound": "notificationSound",
      "Display Album Artwork": "hideAlbumArtwork",
      "Disable Notifications": "notificationsDisabled"
   ]
   
   func applicationDidFinishLaunching(aNotification: NSNotification) {
      initialize()
      
      NSDistributedNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.playbackStateChanged(_:)), name: "com.spotify.client.PlaybackStateChanged", object: nil)
   }
   
   func initialize() {
      if let button = statusItem.button {
         button.image = NSImage(named: "DockIcon")
      }
      
      let menu = NSMenu()
      
      let menuItem1 = NSMenuItem(title: "Hide Album Artwork", action: #selector(AppDelegate.toggleUserPreference(_:)), keyEquivalent: "")
      let menuItem2 = NSMenuItem(title: "Notification Sound", action: #selector(AppDelegate.toggleUserPreference(_:)), keyEquivalent: "")
      let menuItem3 = NSMenuItem(title: "Disable Notifications", action: #selector(AppDelegate.toggleUserPreference(_:)), keyEquivalent: "")
      let menuItem4 = NSMenuItem(title: "Quit Spotnotify", action: #selector(NSApplication.sharedApplication().terminate(_:)), keyEquivalent: "")
      
      menuItem1.state = getUserPreference(userPreferenceMap["Display Album Artwork"]!)
      menuItem2.state = getUserPreference(userPreferenceMap["Notification Sound"]!)
      menuItem3.state = getUserPreference(userPreferenceMap["Disable Notifications"]!)
      
      menu.addItem(menuItem1)
      menu.addItem(menuItem2)
      menu.addItem(menuItem3)
      menu.addItem(NSMenuItem.separatorItem())
      menu.addItem(menuItem4)
      
      statusItem.menu = menu
   }
   
   func getUserPreference(key: String, fallback: Int = 0) -> Int {
      if let preference: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(key) {
         return preference as! Int
      } else {
         return fallback
      }
   }
   
   func setUserPreference(key: String, value: Int) {
      NSUserDefaults.standardUserDefaults().setInteger(value, forKey: key)
      NSUserDefaults.standardUserDefaults().synchronize()
   }
   
   func toggleUserPreference(sender: NSMenuItem) {
      sender.state = Int(!Bool(sender.state))
      setUserPreference(userPreferenceMap[sender.title]!, value: sender.state)
   }
   
   func getAlbumArtwork(trackId: String, callback: (NSImage?) -> Void) {
      let url = "https://api.spotify.com/v1/tracks/" + trackId
      let request = NSMutableURLRequest(URL: NSURL(string: url)!);
      request.HTTPMethod = "GET"
      let session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
      
      session.dataTaskWithRequest(request, completionHandler: {
         data, response, error in
         
         defer {
            session.invalidateAndCancel()
            session.finishTasksAndInvalidate()
         }
         
         if error != nil {
            callback(nil)
         } else {
            do {
               // Convert NSData to Dictionary where keys are of type String, and values are of any type
               let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! [String:AnyObject]
               
               guard let album = json["album"] as? [String: AnyObject],
                  let albumImages = album["images"] as? NSArray,
                  let artworkLocation = albumImages[2]["url"] as? String else {
                     return callback(nil)
               }
               let artwork = NSImage(contentsOfURL: NSURL(string: artworkLocation)!)

               callback(artwork)
            } catch {
               callback(nil)
            }
            
         }
      }).resume()
   }
   
   func notify(title: String, subtitle: String, informativeText: String, contentImage: NSImage?) {
      let notification:NSUserNotification = NSUserNotification()
      notification.title = title
      notification.subtitle = subtitle
      notification.informativeText = informativeText
      notification.contentImage = contentImage
      
      if getUserPreference("notificationSound") == 1 {
         notification.soundName = NSUserNotificationDefaultSoundName
      }
      
      NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
   }
   
   func playbackStateChanged(aNotification: NSNotification) {
      if getUserPreference("notificationsDisabled") == 1 {
         return
      }
      let playbackInfo : [NSObject : AnyObject] = aNotification.userInfo!
      let playbackState  = playbackInfo["Player State"] as! NSString
      
      if playbackState == "Playing" {
         let trackTitle = playbackInfo["Name"] as? String
         let trackArtist = playbackInfo["Artist"] as? String
         let trackAlbum = playbackInfo["Album"] as? String
         
         let frontmostApplication : NSRunningApplication? = NSWorkspace.sharedWorkspace().frontmostApplication
         if frontmostApplication != nil {
            if frontmostApplication?.bundleIdentifier == "com.spotify.client" && getUserPreference("disableWhenSpotifyHasFocus") != 1 {
               return
            } else {
               if getUserPreference("hideAlbumArtwork") == 1 {
                  notify(trackTitle!, subtitle: trackArtist!, informativeText: trackAlbum!, contentImage: nil)
               } else {
                  let trackId = (playbackInfo["Track ID"] as! String).componentsSeparatedByString(":")[2]
                  getAlbumArtwork(trackId, callback: {
                     img in
                     let trackArtwork = img
                     self.notify(trackTitle!, subtitle: trackArtist!, informativeText: trackAlbum!, contentImage: trackArtwork)
                  })
               }
            }
         }
      }
   }
   
   func applicationWillTerminate(aNotification: NSNotification) {
      // Insert code here to tear down your application
   }
}
