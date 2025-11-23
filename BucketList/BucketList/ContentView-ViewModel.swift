//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Deepankar Das on 22/11/25.
//
import CoreLocation
import Foundation
import MapKit
import LocalAuthentication
import SwiftUI

extension ContentView {
    @Observable
    class ViewModel {
        
        private(set) var locations : [Location]
        var selectedLocation : Location?
        var isUnLocked = false
        var isHybridMap = true
        var errorTitle = "Error while authenticate"
        var errorDescription = "Biometric authentication is not available on this device"
        var isAuthenticationFailed = false
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        var icon: String {
            isHybridMap ? "globe.central.south.asia" : "map"
        }
        
        var mapStyle : MapStyle {
            isHybridMap ? .hybrid : .standard
        }
        
        init () {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
                
            }catch{
                locations = []
            }
        }
        
        func addLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
            save()
        }
        
        func updateLocation (location: Location) {
            guard let selectedLocation else { return }
            if let selectedIndex = locations.firstIndex(of: selectedLocation){
                locations[selectedIndex] = location
                save()
            }
            
        }
        func save(){
            do{
                let encodedData = try JSONEncoder().encode(locations)
                try encodedData.write(to: savePath, options: [.atomic, .completeFileProtection])
                
            }catch{
                print("error while reding data")
            }
        }
        
        func authenticate(){
            let context = LAContext()
            var error : NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
                let reason = "Please authenticate yourself to unlock your places."
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){ success, authenticationError in
                    if success{
                        self.isUnLocked = true
                    }else{
                        self.isUnLocked = false
                        self.errorTitle = "Face ID/Touch ID Didn't Match"
                        self.errorDescription = "Please try again."
                        self.isAuthenticationFailed = true
                    }
                    
                }
                
            }else{
                print("error while authenticate")
                isAuthenticationFailed = true
                isUnLocked = true
            }
        }
        
    }
}
