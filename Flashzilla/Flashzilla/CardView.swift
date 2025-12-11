//
//  CardView.swift
//  Flashzilla
//
//  Created by Deepankar Das on 08/12/25.
//

import SwiftUI

struct CardBackgroundModifier: ViewModifier {
    let offset: CGSize
    let isDragging: Bool
    let accessibilityDifferentiateWithoutColor: Bool
    
    var backgroundColor: Color {
        // Only show color while actively dragging
        guard isDragging else { return .clear }
        
        if offset.width > 0 {
            return .green
        } else if offset.width < 0 {
            return .red
        } else {
            return .clear
        }
    }
    
    func body(content: Content) -> some View {
        if accessibilityDifferentiateWithoutColor {
            content
        } else {
            content.background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(backgroundColor)
            )
        }
    }
}

struct CardView: View {
    let card : Card
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    @State private var isDragging = false
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    var result: SwipeDirection {
        if offset.width < 0 {
            .wrong
        } else {
            .correct
        }
    }
    var removal: ((SwipeDirection) -> Void)? = nil
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    accessibilityDifferentiateWithoutColor ? .white : .white.opacity(1 - Double(abs(offset.width / 50)))
                )
                .modifier(CardBackgroundModifier(offset: offset, isDragging: isDragging, accessibilityDifferentiateWithoutColor: accessibilityDifferentiateWithoutColor))
                .shadow(radius: 10)
            VStack{
                if accessibilityVoiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                }else{
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundStyle(.secondary)
                    }
                }
            }.padding(20)
                .multilineTextAlignment(.center)
            
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(offset.width / 5.0))
        .offset(x: offset.width * 5)
        .opacity( 2 - Double(abs(offset.width / 50)))
        .accessibilityAddTraits(.isButton)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    isDragging = true
                }
                .onEnded { _ in
                    isDragging = false
                    if abs(offset.width) > 100 {
                        removal?(result)
                    } else {
                        offset = .zero
                    }
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.bouncy, value: offset)
    }
}

#Preview {
    CardView(card: .example)
}
