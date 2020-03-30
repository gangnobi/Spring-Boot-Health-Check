//
//  CollectionServiceJSON.swift
//  Spring Boot Health Check
//
//  Created by Waytis Laoniyomthai on 29/3/2563 BE.
//  Copyright © 2563 Waytis Laoniyomthai. All rights reserved.
//

import Foundation

struct CollectionServiceJSON: Decodable, Encodable {
    var collectionName: String
    var services: [ServiceJSONItem]
}

struct ServiceJSONItem: Decodable, Encodable {
    var serviceName: String
    var healthCheckURL: String
    var links: [ServiceLinkItem]
}

struct ServiceLinkItem: Decodable, Encodable {
    var name: String
    var url: String
}

struct CollectionServiceView: Identifiable {
    var id = UUID()
    var collectionName: String
    var services: [ServiceJSONItem]
}
