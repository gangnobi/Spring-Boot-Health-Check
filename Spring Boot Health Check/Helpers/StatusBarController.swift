//
//  StatusBarController.swift
//  Spring Boot Health Check
//
//  Created by Waytis Laoniyomthai on 28/3/2563 BE.
//  Copyright © 2563 Waytis Laoniyomthai. All rights reserved.
//

import AppKit

class StatusBarController
{
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    private var statusBarButton: NSStatusBarButton
    private var eventMonitor: EventMonitor?
    
    init(_ popover: NSPopover)
    {
        statusBar = NSStatusBar()
        statusItem = statusBar.statusItem(withLength: 24.0)
        
        statusBarButton = statusItem.button!
        self.popover = popover
        
        statusBarButton.image = #imageLiteral(resourceName: "StatusBarIcon")
        statusBarButton.image?.size = NSSize(width: 18.0, height: 18.0)
        statusBarButton.image?.isTemplate = true
//        statusBarButton.contentTintColor = NSColor.green
        statusBarButton.frame = NSRect(x: 0, y: -2, width: statusBarButton.frame.width, height: statusBarButton.frame.height)
        
        statusBarButton.action = #selector(togglePopover(sender:))
        statusBarButton.target = self
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown], handler: mouseEventHandler)
    }
    
    @objc func togglePopover(sender: AnyObject)
    {
        if popover.isShown
        {
            hidePopover(sender)
        }
        else
        {
            showPopover(sender)
        }
    }
    
    func showPopover(_ sender: AnyObject)
    {
        popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
        eventMonitor?.start()
    }
    
    func hidePopover(_ sender: AnyObject)
    {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func mouseEventHandler(_ event: NSEvent?)
    {
        if popover.isShown
        {
            hidePopover(event!)
        }
    }
}
