//
//  PersistanceManager.swift
//  Guidomia
//
//  Created by Roman Kavinskyi on 7/17/22.
//

import Foundation

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let vehicles = "vehicles"
    }
    
    
    static func retrieveVehicles(completed: @escaping (Result<[VehicleModel], GuidomiaError>) -> Void) {
        
        guard let vehiclesData = defaults.object(forKey: Keys.vehicles) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let vehicles = try decoder.decode([VehicleModel].self, from: vehiclesData)
            completed(.success(vehicles))
        } catch {
            completed(.failure(.unableToLoad))
        }
    }
    
    
    static func save(vehicles: [VehicleModel]) -> GuidomiaError? {
        do {
            let encoder = JSONEncoder()
            let encodedVehicles = try encoder.encode(vehicles)
            defaults.set(encodedVehicles, forKey: Keys.vehicles)
            return nil
        } catch {
            return .unableToSave
        }
    }
}


enum GuidomiaError: String, Error {
    case unableToSave = "There was an error saving vehicles"
    case unableToLoad = "There was an error loading vehicles"
}
