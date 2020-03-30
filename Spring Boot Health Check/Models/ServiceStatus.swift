//
//  ServiceStatus.swift
//  Spring Boot Health Check
//
//  Created by Waytis Laoniyomthai on 29/3/2563 BE.
//  Copyright © 2563 Waytis Laoniyomthai. All rights reserved.
//

import Foundation

struct ServiceStatus {
    var isUp: Bool
    var httpStatusCode: UInt
    var updatedDateTime:Date = Date()
}
