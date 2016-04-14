//
//  ViewController.swift
//  Spotnotify
//
//  Created by Chris Cho on 4/12/16.
//  Copyright © 2016 Chris Cho. All rights reserved.
//

import Cocoa

class ViewController: NSObject {
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    
    let notificationDelegate = NotificationController()
    
    let userPreferenceMap: [String: String] = [
        "Notification Sound": "notificationSound",
        "Display Album Artwork": "displayAlbumArtwork",
        "Disable Notifications": "notificationsDisabled",
        "Launch on Startup": "launchOnStartup"
    ]

    override func awakeFromNib() {
        // set notification delegate
        NSUserNotificationCenter.defaultUserNotificationCenter().delegate = notificationDelegate
        
        // init menu
        if let button = statusItem.button {
            button.image = NSImage(named: "DockIcon")
        }
        
        let menu = NSMenu()
        let menuItem1 = NSMenuItem(title: "Display Album Artwork", action: #selector(toggleUserPreference(_:)), keyEquivalent: "")
        let menuItem2 = NSMenuItem(title: "Disable Notifications", action: #selector(toggleUserPreference(_:)), keyEquivalent: "")
        let menuItem3 = NSMenuItem(title: "Launch on Startup", action: #selector(toggleUserPreference(_:)), keyEquivalent: "")
        let menuItem4 = NSMenuItem(title: "Quit Spotnotify", action: #selector(NSApplication.sharedApplication().terminate(_:)), keyEquivalent: "")
        
        menuItem1.state = getUserPreference(userPreferenceMap["Display Album Artwork"]!, fallback: 1)
        menuItem2.state = getUserPreference(userPreferenceMap["Disable Notifications"]!)
        menuItem3.state = getUserPreference(userPreferenceMap["Launch on Startup"]!)
        
        menuItem1.target = self
        menuItem2.target = self
        menuItem3.target = self
        
        menu.addItem(menuItem1)
        menu.addItem(menuItem2)
        menu.addItem(menuItem3)
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(menuItem4)
        
        statusItem.menu = menu
        
        // main listener
        NSDistributedNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.playbackStateChanged(_:)), name: "com.spotify.client.PlaybackStateChanged", object: nil)
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
        if key == "launchOnStartup" {
            LaunchStarter.toggleLaunchAtStartup(value)
        }
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
        
        session.dataTaskWithRequest(request, completionHandler: { data, response, error in
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
                    if getUserPreference("displayAlbumArtwork", fallback: 1) == 1 {
                        let trackId = (playbackInfo["Track ID"] as! String).componentsSeparatedByString(":")[2]
                        getAlbumArtwork(trackId, callback: {
                            img in
                            let trackArtwork = img
                            self.notificationDelegate.notify(trackTitle!, subtitle: trackArtist!, informativeText: trackAlbum!, contentImage: trackArtwork)
                        })
                    } else {
                        notificationDelegate.notify(trackTitle!, subtitle: trackArtist!, informativeText: trackAlbum!, contentImage: nil)
                    }
                }
            }
        }
    }
    
}
