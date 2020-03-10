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
        toggleMirroring {
            NSApp.terminate(self)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func getDisplays() -> [CGDirectDisplayID] {
        var displayCount: UInt32 = 0;
        if CGGetActiveDisplayList(0, nil, &displayCount) == CGError.success {
            let allocated = Int(displayCount)
            let displays = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: allocated)
            defer { displays.deallocate() }

            if CGGetActiveDisplayList(displayCount, displays, &displayCount) == CGError.success {
                var result: [CGDirectDisplayID] = []
                for i in 0 ..< displayCount {
                    result.append(displays[Int(i)])
                }
                return result
            }
        }
        
        return []
    }
    
    func toggleMirroring(completion: @escaping () -> (Void)) {
        let displays = getDisplays()
        let main = CGMainDisplayID()
        
        for display in displays {
            if display != main {
                var token: CGDisplayConfigRef?
                CGBeginDisplayConfiguration(&token)
                CGConfigureDisplayMirrorOfDisplay(token, display, main)
                CGCompleteDisplayConfiguration(token, .forSession)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now().advanced(by: .seconds(10))) {
                    CGBeginDisplayConfiguration(&token)
                    CGConfigureDisplayMirrorOfDisplay(token, display, kCGNullDirectDisplay)
                    CGCompleteDisplayConfiguration(token, .forSession)
                    completion()
                }
                break
            }
        }
    }
    
    func toggleModes(completion: @escaping () -> (Void)) {
        let display = CGMainDisplayID()
        var token: CGDisplayConfigRef?
        let current = CGDisplayCopyDisplayMode(display)
        if let cgModes = CGDisplayCopyAllDisplayModes(display, nil), let modes = cgModes as? Array<CGDisplayMode> {
            for mode in modes {
                if mode != current {
                    CGBeginDisplayConfiguration(&token)
                    CGDisplaySetDisplayMode(display, mode, nil)
                    CGCompleteDisplayConfiguration(token, .forSession)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now().advanced(by: .seconds(10))) {
                        CGBeginDisplayConfiguration(&token)
                        CGDisplaySetDisplayMode(display, current, nil)
                        CGCompleteDisplayConfiguration(token, .forSession)
                        completion()
                    }
                    break
                }
            }
        }
        
    }

}

