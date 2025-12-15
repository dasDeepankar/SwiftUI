//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Deepankar Das on 12/12/25.
//

import SwiftUI


struct ContentView: View {
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]
    
    var body: some View {
        GeometryReader { fullView in
            ScrollView(.vertical) {
                ForEach(0..<50) { index in
                    GeometryReader { proxy in
                        Text("Row #\(index)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .background(Color(hue: min(1.0, proxy.frame(in: .global).minY / fullView.size.height), saturation: 1.0, brightness: 1.0))
                            .clipShape(.capsule)
                            .rotation3DEffect(.degrees(proxy.frame(in: .global).minY - fullView.size.height / 2) / 5, axis: (x: 0, y: 1, z: 0))
                            .opacity(proxy.frame(in: .global).minY < 200 ? proxy.frame(in: .global).minY / 200 : 1)
                            .scaleEffect(max(0.5, proxy.frame(in: .global).minY / fullView.size.height))
                            
                    }
                    .frame(height: 60)
                    
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
