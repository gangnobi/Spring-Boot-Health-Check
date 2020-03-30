//
//  ServiceCollectionService.swift
//  Spring Boot Health Check
//
//  Created by Waytis Laoniyomthai on 29/3/2563 BE.
//  Copyright © 2563 Waytis Laoniyomthai. All rights reserved.
//

import Foundation

class ServiceCollectionService {
    let defaults = UserDefaults.standard

    func importCollectionService(fileUrl: URL) -> Bool {
        // Getting data from JSON file using the file URL

        let decoder = JSONDecoder()
        guard
            let data = try? Data(contentsOf: fileUrl, options: .mappedIfSafe),
            let collectionServiceData: [CollectionServiceJSON] = try? decoder.decode([CollectionServiceJSON].self, from: data)
        else {
            return false
        }
        collectionServiceData.forEach { collectionService in
            collectionService.services.forEach { serviceItem in
                print(serviceItem)
            }
        }

        var savedCollectionServiceData: [CollectionServiceJSON] = getCollectionServices()
        savedCollectionServiceData.append(contentsOf: collectionServiceData)
        self.saveCollectionServices(data:savedCollectionServiceData)
        print("SAVED")
        return true
    }

    func saveCollectionServices(data: [CollectionServiceJSON]) {
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(data) else {
            return
        }
        defaults.set(encoded, forKey: DefaultsKeys.serviceCollectionsKey)
    }

    func removeServiceCollection(collectionName: String) {
        saveCollectionServices(data: getCollectionServices().filter { item -> Bool in
            item.collectionName != collectionName
        })
    }

    func getCollection(collectionName: String) -> CollectionServiceJSON? {
        return getCollectionServices().first { item -> Bool in
            item.collectionName == collectionName
        }
    }

    func getCollectionServices() -> [CollectionServiceJSON] {
        let decoder = JSONDecoder()
        guard
            let savedCollection = defaults.object(forKey: DefaultsKeys.serviceCollectionsKey) as? Data,
            let result = try? decoder.decode([CollectionServiceJSON].self, from: savedCollection)
        else {
            return []
        }
        return result
    }
}
