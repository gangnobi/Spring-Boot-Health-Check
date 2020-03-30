//
//  ServiceDetail.swift
//  Spring Boot Health Check
//
//  Created by Waytis Laoniyomthai on 29/3/2563 BE.
//  Copyright © 2563 Waytis Laoniyomthai. All rights reserved.
//

import Foundation

struct ServiceLinkItemViewModel: Identifiable {
    var id = UUID()
    var name: String
    var url: String
}

class ServiceDetailViewModel: Identifiable, ObservableObject {
    private let serviceDetailService = ServiceDetailService()

    var id = UUID()
    var serviceName: String
    var serviceEndpoint: String
    @Published var status: ServiceStatus?
    var links: [ServiceLinkItemViewModel]

    init(serviceName: String, serviceEndpoint: String, links: [ServiceLinkItem]) {
        self.serviceName = serviceName
        self.serviceEndpoint = serviceEndpoint
        
        self.links = links.map { item in
            ServiceLinkItemViewModel(name: item.name, url: item.url)
        }
        
        serviceDetailService.getServiceStatus(serviceEndpoint: serviceEndpoint) { status in
            DispatchQueue.main.async { self.status = status
            }
        }
    }

    func fetchStatus(completion: @escaping (Bool) -> ()) {
        serviceDetailService.getServiceStatus(serviceEndpoint: serviceEndpoint) { status in
            DispatchQueue.main.async {
                self.status = status
                completion(true)
            }
        }
    }
}
