//
//  EventMonitor.swift
//  Spring Boot Health Check
//
//  Created by Waytis Laoniyomthai on 28/3/2563 BE.
//  Copyright © 2563 Waytis Laoniyomthai. All rights reserved.
//

import Cocoa

class EventMonitor
{
    private var monitor: Any?
    private let mask: NSEvent.EventTypeMask
    private let handler: (NSEvent?) -> Void
    
    public init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> Void)
    {
      self.mask = mask
      self.handler = handler
    }

    deinit
    {
      stop()
    }

    public func start()
    {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler) as! NSObject
    }

    public func stop()
    {
      if monitor != nil
      {
        NSEvent.removeMonitor(monitor!)
        monitor = nil
      }
    }
}
