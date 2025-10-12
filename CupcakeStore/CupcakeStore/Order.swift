//
//  Order.swift
//  CupcakeCorner
//
//  Created by Deepankar Das on 09/10/25.
//

import Foundation

@Observable

class Order: Codable {
    
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specailRequests = "specailRequests"
        case _extraFrosting = "extraFrosting"
        case _extraSprinkles = "extraSprinkles"
        case _name = "name"
        case _city = "city"
        case _streetAddress = "streetAddress"
        case _zip = "zip"
    }
    static let types = ["Vanilla", "Chocolate", "Strawberry", "Rainbow"]
    
    var type = 0
    var quantity: Int = 3
    
    var specailRequests = false {
        didSet{
            if !specailRequests {
                extraFrosting = false
                extraSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var extraSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var isTexfieldValid: Bool {
        
        if  name.isBlank || streetAddress.isBlank || city.isBlank  || zip.isBlank  {
            return false
        }
        return true
    }
 
    
    var cost : Decimal {
        // $2 per cake
        var cost = Decimal(quantity) * 2
        
        // complicated cakes cost more
        cost += Decimal(type) / 2
        
        // $1/cake for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        // $0.50/cake for sprinkles
        if extraSprinkles {
            cost += Decimal(quantity) / 2
        }
        
        return cost
    }
    init() {
        if let addressData = UserDefaults.standard.data(forKey: "address"), let decodedAddress = try? JSONDecoder().decode(Address.self, from: addressData) {
            self.name = decodedAddress.name
            self.streetAddress = decodedAddress.streetAddress
            self.city = decodedAddress.city
            self.zip = decodedAddress.zip
        }
    }
}

