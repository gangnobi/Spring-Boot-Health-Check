//
//  ServiceDetailService.swift
//  Spring Boot Health Check
//
//  Created by Waytis Laoniyomthai on 29/3/2563 BE.
//  Copyright © 2563 Waytis Laoniyomthai. All rights reserved.
//

import Foundation

class ServiceDetailService {
    func getServiceStatus(serviceEndpoint: String, completeion: @escaping (ServiceStatus?) -> ()) {
        guard let url = URL(string: serviceEndpoint) else {
            completeion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completeion(nil)
                return
            }
            guard let data = data, error == nil else {
                completeion(ServiceStatus(isUp: false, httpStatusCode: UInt(httpResponse.statusCode)))
                return
            }
            let serviceStatusResponse = try? JSONDecoder().decode(SpringBootStatus.self, from: data)
            if let serviceStatusResponse: SpringBootStatus = serviceStatusResponse {
                completeion(ServiceStatus(isUp: serviceStatusResponse.status == "UP", httpStatusCode: UInt(httpResponse.statusCode)))
            } else {
                completeion(ServiceStatus(isUp: false, httpStatusCode: UInt(httpResponse.statusCode)))
            }
        }.resume()
    }
}
