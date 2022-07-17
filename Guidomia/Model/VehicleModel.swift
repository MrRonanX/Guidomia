//
//  VehicleModel.swift
//  Guidomia
//
//  Created by Roman Kavinskyi on 7/16/22.
//

import Foundation

struct SectionModel {
    var expended = false
    let vehicle: VehicleModel
}

struct VehicleModel: Codable {
    let consList: [String]
    let customerPrice: Double
    let make: String
    let marketPrice: Double
    let model: String
    let prosList: [String]
    let rating: Int
    
    var imageName: String {
        switch make {
        case "Land Rover":      return "Range_Rover"
        case "Alpine":          return "Alpine_roadster"
        case "BMW":             return "BMW_330i"
        case "Mercedes Benz":   return "Mercedez_benz_GLC"
        default:                return "placeholder"
        }
    }
    
    var vehicleName: String {
        switch make {
        case "Land Rover":      return "Range Rover"
        case "Alpine":          return "Alpine Roadster"
        case "BMW":             return "BMW 330i"
        case "Mercedes Benz":   return make
        default:                return "placeholder"
        }
    }
    
    var displayedPrice: String {
        String(Int(customerPrice) / 1000) + "k"
    }
    
    var bulletPoints: [String] {
        var result = [String]()
        if !(prosList.filter { !$0.isEmpty }).isEmpty {
            result.append("Pros:")
            result.append(contentsOf: prosList.filter { !$0.isEmpty })
        }
        
        if !(consList.filter { !$0.isEmpty }).isEmpty {
            result.append("Cons:")
            result.append(contentsOf: consList.filter { !$0.isEmpty })
        }
        
        return result
    }
}


