//
//  Views.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation
import SwiftUI

struct PlayScreenHeader: View {
    
    var viewModel: PlayViewModel
    var level: QuestionLevel
    var question: String
    var isHintEnabled: Bool
    var onHintClicked: () -> Void
    var onBack: () -> Void

    var body: some View {
        
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        if viewModel.shouldPlaySound() {
                            Ranking_Trivia_Latam.playSound("sound_click")
                        }
                        onBack()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Circle()
                                        .stroke(Color.black, lineWidth: 1)
                                )
                            Image("ic_back")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 20)
                        }
                    }
                    Spacer()
                    Image("logo_no_background_letters")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 30)
                }
                .padding(.horizontal, 12)
                
                ScrollView {
                    Text(question)
                        .font(.custom("FredokaCondensed-Semibold", size: 26))
                        .shadow(color: .gray, radius: 1, x: 2, y: 2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .lineSpacing(0)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 10)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 150)
            .background(Color.appCustomBlue.opacity(0.5))
            .padding(.bottom, 25)
            
            VStack {
                Spacer()
                Color.gray.frame(height: 5)
                    .padding(.bottom, 11)
            }
            .frame(height: 158)
            
            VStack {
                Spacer()
                ZStack {
                    HStack {
                        Spacer()
                        ButtonExitOrRetry(
                            onClick: {},
                            content: {
                                Text(String(format: NSLocalizedString("game_level", comment: ""), level.rawValue))
                                    .font(.custom("FredokaCondensed-Semibold", size: 16))
                                    .foregroundColor(.black)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 20)
                            }
                        )
                        Spacer()
                    }
                    if isHintEnabled {
                        HStack {
                            Spacer()
                            Button(action: {
                                if viewModel.shouldPlaySound() {
                                    Ranking_Trivia_Latam.playSound("sound_click")
                                }
                                onHintClicked()
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 32, height: 32)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.black, lineWidth: 2)
                                        )
                                    Image("ic_bulb")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                }
                            }
                            .padding(.trailing, 15)
                        }
                    }
                }
            }
            .frame(height: 158)
        }
        .frame(width: UIScreen.screenWidth)
    }
}


struct CountdownTimer: View {
    
    @State private var timeLeft: Int
    @State private var isTimerRunning: Bool = false

    
    @State private var minutes = 0
    @State private var seconds = 0
    
    let totalTime: Int
    let isPaused: Bool
    let onTimeFinish: () -> Void

    init(totalTime: Int, isPaused: Bool, onTimeFinish: @escaping () -> Void) {
        self.totalTime = totalTime
        self.isPaused = isPaused
        self.onTimeFinish = onTimeFinish
        _timeLeft = State(initialValue: totalTime)
    }

    var body: some View {
        Text(String(format: "%02d:%02d", minutes, seconds))
            .font(.custom("FredokaCondensed-Semibold", size: 34))
            .shadow(color: .gray, radius: 2, x: 2, y: 2)
            .foregroundColor(Color.gray)
            .padding(.vertical, 18)
            .padding(.horizontal, 24)
            .background(Color.appYellow)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black, lineWidth: 2)
            )
            .onAppear {
                startTimer()
            }
            .onChange(of: isPaused) { newValue in
                if newValue {
                    resetTimer()
                } else {
                    startTimer()
                }
            }
            .onChange(of: timeLeft) { newValue in
                minutes = Int(timeLeft) / 60
                seconds = Int(timeLeft) % 60
                if newValue <= 0 {
                    isTimerRunning = false
                    onTimeFinish()
                }
            }
    }

    private func startTimer() {
        guard !isTimerRunning && !isPaused else { return }
        isTimerRunning = true
        runTimer()
    }

    private func runTimer() {
        if isTimerRunning {
            guard timeLeft > 0 && !isPaused else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                timeLeft -= 1
                runTimer()
            }
        }
        
    }

    private func resetTimer() {
        isTimerRunning = false
    }
}


struct TimerView: View {
    let timeLeft: TimeInterval
    private let limitTime: TimeInterval = 7.0 // 7 seconds for example

    var body: some View {
        let minutes = Int(timeLeft) / 60
        let seconds = Int(timeLeft) % 60

        VStack {
            Button(action: {
                }) {
                Text(String(format: "%02d:%02d", minutes, seconds))
                    .font(.custom("FredokaCondensed-Semibold", size: 34))
                    .shadow(color: .gray, radius: 2, x: 2, y: 2)
                    .foregroundColor(Color.gray)
                    .padding(.vertical, 18)
                    .padding(.horizontal, 24)
                    .background(Color.appYellow)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 2)
                    )
            }
            .disabled(true)
        }
    }
}



struct BottomButton: View {
    
    var timeUp: Bool
    var spaces: [EmptySpace]
    var onClick: () -> Void

    @State private var buttonEnabled: Bool = false

    var body: some View {
        VStack {
            Button(action: {
                if buttonEnabled {
                    onClick()
                }
            }) {
                Text(LocalizedStringKey("game_done"))
                    .font(.custom("FredokaCondensed-Semibold", size: 34))
                    .shadow(color: .gray, radius: 2, x: 2, y: 2)
                    .foregroundColor(buttonEnabled ? .white : Color.white.opacity(0.6))
                    .padding(.vertical, 18)
                    .padding(.horizontal, 24)
                    .background(buttonEnabled ? Color.blue : Color.gray.opacity(0.5))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(buttonEnabled ? Color.black : Color.gray, lineWidth: 2)
                    )
            }
            .disabled(!buttonEnabled)
            .onAppear {
                buttonEnabled = !timeUp && spaces.isEmpty
            }
            .onChange(of: timeUp) { newValue in
                buttonEnabled = !newValue && spaces.isEmpty
            }
            .onChange(of: spaces) { newValue in
                buttonEnabled = !timeUp && newValue.isEmpty
            }
        }
    }
}
