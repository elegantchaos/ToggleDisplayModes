//
//  AppDelegate.swift
//  Toggle Modes
//
//  Created by Developer on 10/03/2020.
//  Copyright © 2020 Elegant Chaos. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        toggleModes()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now().advanced(by: .seconds(10))) {
            NSApp.terminate(self)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func toggleModes() {
        let display = CGMainDisplayID()
        var token: CGDisplayConfigRef?
        let current = CGDisplayCopyDisplayMode(display)
        if let cgModes = CGDisplayCopyAllDisplayModes(display, nil), let modes = cgModes as? Array<CGDisplayMode> {
            for mode in modes {
                if mode != current {
                    CGBeginDisplayConfiguration(&token)
                    CGDisplaySetDisplayMode(display, mode, nil)
                    CGCompleteDisplayConfiguration(token, .forSession)
                    break
                }
            }
        }
        
        CGBeginDisplayConfiguration(&token)
        CGDisplaySetDisplayMode(display, current, nil)
        CGCompleteDisplayConfiguration(token, .forSession)
    }

}

