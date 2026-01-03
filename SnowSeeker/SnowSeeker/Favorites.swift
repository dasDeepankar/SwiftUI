//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Deepankar Das on 02/01/26.
//

import SwiftUI

@Observable
class Favorites {
    // the actual resorts the user has favorited
    private var resorts: Set<String>
    
    // the key we're using to read/write in UserDefaults
    private let key = "Favorites"
    
    init() {
        // load our saved data
        
        // still here? Use an empty array
        if let data = UserDefaults.standard.data(forKey: key) {
            if let savedResorts = try? JSONDecoder().decode(Set<String>.self, from: data) {
                resorts = savedResorts
            }else{
                resorts = []
            }
        }else{
            resorts = []
        }
    }
    
    // returns true if our set contains this resort
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    // adds the resort to our set and saves the change
    func add(_ resort: Resort) {
        resorts.insert(resort.id)
        save()
    }
    
    // removes the resort from our set and saves the change
    func remove(_ resort: Resort) {
        resorts.remove(resort.id)
        save()
    }
    
    func save() {
        // write out our data
        if let data = try? JSONEncoder().encode(resorts) {
            UserDefaults.standard.set(data, forKey: key)
        }else{
            print("Not able to save data")
        }
    }
}
