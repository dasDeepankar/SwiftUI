//
//  DiceView.swift
//  HighRollers
//
//  Created by Deepankar Das on 17/12/25.
//
import Combine
import SwiftUI

struct FlickNumberView : View {
    @State private var flickNumber = 1
    @State private var counter = 0
    var stopRolling: (Int) -> Void
    let sides: Int
    let maxFlicks = 15 // Fixed flicker count for consistent experience
    let timer = Timer.publish(every: 0.1, tolerance: 0.02, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text("\(flickNumber)")
            .font(.largeTitle)
            .foregroundStyle(.white)
            .onReceive(timer) { _ in
                withAnimation(.bouncy) {
                    flickNumber = Int.random(in: 1...sides)
                }
                if counter >= maxFlicks {
                    timer.upstream.connect().cancel()
                    // Haptic feedback when dice settles
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    stopRolling(flickNumber)
                }
                counter += 1
            }
    }
    
    init(stopRolling: @escaping (Int) -> Void, sides: Int) {
        self.stopRolling = stopRolling
        self.sides = sides
    }
}
struct DiceView: View {
    let colors: [Color] = [.red, .blue, .green, .purple, .brown, .orange, .pink, .cyan, .indigo, .mint]
    var dice: Dice
    var index: Int
    var sides: Int { dice.sides }
    var onRoll: ((Int) -> Void)?
    @State private var showFlicker = false
    @State private var diceResult: Int?
    
    // Current displayed result for accessibility
    private var currentResult: Int? {
        diceResult ?? dice.lastRoll
    }
    
    var body: some View {
        VStack {
            if showFlicker {
                FlickNumberView(stopRolling: { lastNumber in
                    diceResult = lastNumber
                    onRoll?(lastNumber)
                    showFlicker.toggle()
                }, sides: sides)
            } else {
                Text("sides: \(sides)")
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
                Image(systemName: "dice")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .accessibilityHidden(true)
                Spacer()
                if let result = currentResult {
                    Text("rolled: \(result)")
                        .font(.headline)
                        .foregroundStyle(.white)
                } else {
                    Text("?")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
            }
        }
        .frame(width: 100, height: 100)
        .padding()
        .background(colors[index % colors.count]) // Safe index with modulo
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .onTapGesture {
            // Light haptic when starting roll
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            showFlicker.toggle()
        }
        // Accessibility
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabelText)
        .accessibilityHint("Double tap to roll this die")
        .accessibilityAddTraits(.isButton)
    }
    
    private var accessibilityLabelText: String {
        if let result = currentResult {
            return "\(sides)-sided die, last rolled \(result)"
        } else {
            return "\(sides)-sided die, not yet rolled"
        }
    }
}

#Preview {
    DiceView(dice: Dice(sides: 50), index: 1)
}
