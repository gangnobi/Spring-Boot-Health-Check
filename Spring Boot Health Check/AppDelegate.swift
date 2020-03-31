//
//  AppDelegate.swift
//  Spring Boot Health Check
//
//  Created by Waytis Laoniyomthai on 27/3/2563 BE.
//  Copyright © 2563 Waytis Laoniyomthai. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var popover = NSPopover()
    var statusBar: StatusBarController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        // Create the SwiftUI view that provides the contents
        let contentView = ContentView()
        let settings = UserSettings()
        // Set the SwiftUI's ContentView to the Popover's ContentViewController
        
        popover.contentViewController = MainViewController()
        popover.contentSize = NSSize(width: 360, height: 360)
        popover.behavior = .transient
        popover.contentViewController?.view = NSHostingView(rootView: contentView.environmentObject(settings))

        // Create the Status Bar Item with the Popover
        statusBar = StatusBarController(popover)
        settings.statusBarButton = statusBar?.statusBarButton
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

struct AppDelegate_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
