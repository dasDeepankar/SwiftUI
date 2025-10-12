//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Deepankar Das on 09/10/25.
//

import SwiftUI

struct AddressView: View {
   @Bindable var order : Order
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
            }
            Section{
                NavigationLink("Checkout") {
                    CheckoutView(order: order).onAppear {
                        let address = Address(name: order.name, streetAddress: order.streetAddress, city: order.city, zip: order.zip)
                        if let encodeData = try? JSONEncoder().encode(address) {
                            UserDefaults.standard.set(encodeData, forKey: "address")
                        }
                        
                        
                    }
                }
            }.disabled(!order.isTexfieldValid)
        }.navigationTitle("Delivery details")
            .navigationBarTitleDisplayMode(.inline)
        
    }
}

#Preview {
    NavigationStack{
        AddressView(order: Order())
    }
   
}
