//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Deepankar Das on 24/08/25.
//

import SwiftUI


struct TitleView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
            .padding()
    }
}
extension View {
    func showTitle() -> some View {
        modifier(TitleView())
    }
}

struct FullWidthButton : ViewModifier {
   func body (content: Content) -> some View {
       content
           .frame(maxWidth: .infinity , maxHeight: 60)
           .background(Color.blue)
           .foregroundColor(.white)
           .cornerRadius(20)
           .padding(.horizontal)
    }
}

extension Button {
    func fullWidth() -> some View {
        modifier(FullWidthButton())
    }
}
   
struct ContentView: View {

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .showTitle()
        }
        .padding()
        
        Button{
            
        }label: {
            Text("Tap me")
        }
        .fullWidth()
    }
}

#Preview {
    ContentView()
}
