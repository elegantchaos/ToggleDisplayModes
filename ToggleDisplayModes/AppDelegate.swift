//
//  AppDelegate.swift
//  Toggle Modes
//
//  Created by Developer on 10/03/2020.
//  Copyright © 2020 Elegant Chaos. All rights reserved.
//

import Cocoa
import Displays

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        toggleMirroring {
            NSApp.terminate(self)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func toggleMirroring(completion: @escaping () -> (Void)) {
        let displays = Display.active
        let main = Display.main
        
        for display in displays {
            if display != main {
                display.mirror(to: main)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now().advanced(by: .seconds(10))) {
                    display.unmirror()
                    completion()
                }
                break
            }
        }
    }
    
    func toggleModes(completion: @escaping () -> (Void)) {
        var display = Display.main
        let current = display.mode
        let modes = display.modes
        for mode in modes {
            if mode != current {
                display.mode = mode
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now().advanced(by: .seconds(10))) {
                    display.mode = current
                    completion()
                }
                break
            }
        }
        
    }
}

