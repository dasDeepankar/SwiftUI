//
//  ContentView.swift
//  Flashzilla
//
//  Created by Paul Hudson on 08/05/2024.
//
import Combine
import SwiftUI


extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset * 10)
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled

    @State private var userCards = UserCards()

    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @Environment(\.scenePhase) var scenePhase
    @State private var showingEditScreen = false

    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()

            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)

                ZStack {
                    ForEach(userCards.cards) { card in
                        let index = userCards.cards.firstIndex(where: { $0.id == card.id }) ?? 0
                        
                        CardView(card: card) { direction in
                           withAnimation {
                               userCards.removeCard(at: index, for: direction)
                           }
                        }
                        .stacked(at: index, in: userCards.cards.count)
                        .allowsHitTesting(index == userCards.cards.count - 1)
                        .accessibilityHidden(index < userCards.cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)

                if userCards.cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundStyle(.black)
                        .clipShape(.capsule)
                }
            }

            VStack {
                HStack {
                    Spacer()

                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(.circle)
                    }
                }

                Spacer()
            }
            .foregroundStyle(.white)
            .font(.largeTitle)
            .padding()

            if (accessibilityDifferentiateWithoutColor || accessibilityVoiceOverEnabled) && !userCards.cards.isEmpty {
                VStack {
                    Spacer()

                    HStack {
                        Button {
                            withAnimation {
                                userCards.removeCard(at: userCards.cards.count - 1, for: SwipeDirection.wrong)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect.")

                        Spacer()

                        Button {
                            withAnimation {
                                userCards.removeCard(at: userCards.cards.count - 1, for: SwipeDirection.correct)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct.")
                    }
                }
            }
        }
        .onReceive(timer) { time in
            guard userCards.isActive else { return }

            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                if userCards.cards.isEmpty == false {
                    userCards.isActive = true
                }
            } else {
                userCards.isActive = false
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards){
            EditCards()
        }
        .onAppear(perform: resetCards)
    }




    func resetCards() {
        timeRemaining = 100
        userCards.isActive = true
        userCards.loadData()
    }
}

#Preview {
    ContentView()
}

