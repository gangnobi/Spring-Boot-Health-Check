//
//  UserSettings.swift
//  Spring Boot Health Check
//
//  Created by Waytis Laoniyomthai on 30/3/2563 BE.
//  Copyright © 2563 Waytis Laoniyomthai. All rights reserved.
//

import Foundation

import Cocoa
import SwiftUI

class UserSettings: ObservableObject {
    @Published var onRefresh = true
    var statusBarButton: NSStatusBarButton?
}
