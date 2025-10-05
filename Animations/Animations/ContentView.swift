//
//  ContentView.swift
//  Animations
//
//  Created by Deepankar Das on 07/09/25.
//

import SwiftUI

struct CornerRotationModifier : ViewModifier  {
    
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
    
}

extension AnyTransition {
    static var  pivot : AnyTransition{
        .modifier(active: CornerRotationModifier(amount: -90, anchor: .topLeading),
                  identity: CornerRotationModifier(amount: 0, anchor: .topLeading))
    }
}

struct ContentView: View {
    
    @State private var isShowView = false
    
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.blue)
                .frame(width: 200, height: 200)
            if isShowView {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.pivot)
            }
        }.onTapGesture {
            withAnimation {
                isShowView.toggle()
            }
        }
        
    }
}

#Preview {
    ContentView()
}
