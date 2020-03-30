//
//  ServiceDetail.swift
//  Spring Boot Health Check
//
//  Created by Waytis Laoniyomthai on 29/3/2563 BE.
//  Copyright © 2563 Waytis Laoniyomthai. All rights reserved.
//

import Foundation

struct ServiceDetail: Identifiable {
    var id = UUID()
    var serviceName: String
    var serviceEndpoint: String
    var status: ServiceStatus
    var updateDateTime: Date?
    var logUrl: String = ""
    
    init(serviceName:String,serviceEndpoint:String,logUrl:String) {
        self.serviceName = serviceName
        self.serviceEndpoint = serviceEndpoint
        self.logUrl = logUrl
        self.status = ServiceDetailService.getServiceStatus(ServiceDetailService)
    }
}
