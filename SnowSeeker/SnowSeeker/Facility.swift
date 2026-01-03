//
//  Facility.swift
//  SnowSeeker
//
//  Created by Deepankar Das on 02/01/26.
//

import SwiftUI

struct Facility : Identifiable {
    var id = UUID()
    var name : String
    
    private let icons = [
        "Accommodation": "house",
        "Beginners": "1.circle",
        "Cross-country": "map",
        "Eco-friendly": "leaf.arrow.circlepath",
        "Family": "person.3"
    ]
    private let descriptions = [
        "Accommodation": "This resort has popular on-site accommodation.",
        "Beginners": "This resort has lots of ski schools.",
        "Cross-country": "This resort has many cross-country ski routes.",
        "Eco-friendly": "This resort has won an award for environmental friendliness.",
        "Family": "This resort is popular with families."
    ]

    var icon: some View {
        if let iconName = icons[name] {
            Image(systemName: iconName)
                .accessibilityLabel(name)
                .foregroundStyle(.secondary)
        }else{
            fatalError("Unknown facility type: \(name)")
        }
       
    }
    var description: String {
        if let message = descriptions[name] {
            message
        } else {
            fatalError("Unknown facility type: \(name)")
        }
    }
}
