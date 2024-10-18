//
//  Views.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation
import SwiftUI

struct PlayScreenHeader: View {
    
    var level: QuestionLevel
    var question: String
    var onBack: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    Spacer(minLength: 40)
                    HStack {
                        Button(action: {
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
                    .padding(.horizontal, 10)
                    
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
                    Spacer()
                }
                .frame(height: 200)
                .background(Color.appCustomBlue.opacity(0.5))
                .padding(.bottom, 15)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ButtonExitOrRetry(
                            onClick: {},
                            content: {
                                Text("Nivel \(level.rawValue)")
                                    .font(.custom("FredokaCondensed-Semibold", size: 16))
                                    .foregroundColor(.black)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 20)
                            }
                        )
                        Spacer()
                    }
                }
                .frame(height: 200)
            }
            .frame(width: geometry.size.width, height: 200)
        }
    }
}

#Preview {
    PlayScreenHeader(
        level: .I,
        question: "Hello there sldflsjd flaksdj lsdhfkasjhd fksahdfk weurweyiuwyiwe 93847934759384b,cxmvxskdjfh",
        onBack: {}
    )
}

struct HeaderLevel: View {
    
    var level: Int

    var body: some View {
        ZStack {
            // Fondo amarillo con bordes redondeados
            Color.yellow
                .cornerRadius(20) // Bordes redondeados
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 2) // Borde negro
                )
                .padding(.horizontal) // Espaciado horizontal opcional

            // Texto centrado
            Text("Level \(level)") // Cambia a la traducción correspondiente
                .font(.system(size: 18)) // Ajusta la fuente según sea necesario
                .multilineTextAlignment(.center)
                .foregroundColor(Color.gray) // Color del texto
                .padding(.vertical, 4) // Padding vertical
                .padding(.horizontal, 16) // Padding horizontal
        }
        .frame(minHeight: 40) // Altura mínima opcional
    }
}

/*struct HeaderDivisions: View {
    var body: some View {
        VStack {
            Spacer()
                .frame(width: .infinity, height: 14)
                .background(Color.gray)
                //.shadow(radius: 5)
            
            Spacer()
                .frame(height: 2)
                .background(Color.gray)
                //.shadow(radius: 5)
        }
        .frame(maxWidth: .infinity)
    }
}*/

/*#Preview {
    PlayScreenHeader(
        level: .I,
        question: "Hola mundo! Este es un mensaje largo para ver como se comporta la pantalla con más texto aquí",
        onBack: {
            
        }
    )
}*/

struct CountdownTimer: View {
    
    @State private var timeLeft: TimeInterval
    @State private var isTimerRunning: Bool = true
    
    let totalTime: TimeInterval
    let isPaused: Bool
    let onTimeFinish: () -> Void

    init(totalTime: TimeInterval, isPaused: Bool, onTimeFinish: @escaping () -> Void) {
        self.totalTime = totalTime
        self.isPaused = isPaused
        self.onTimeFinish = onTimeFinish
        _timeLeft = State(initialValue: totalTime)
    }

    var body: some View {
        TimerView(timeLeft: timeLeft)
            .onAppear {
                runTimer()
            }
            .onChange(of: isPaused) { old, new in
                runTimer()
            }
    }

    func runTimer() {
        if isTimerRunning && !isPaused {
            if timeLeft > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    timeLeft -= 1.0
                    runTimer() // Recursive call to keep reducing time
                }
            } else {
                isTimerRunning = false
                onTimeFinish()
            }
        }
    }
}

/*#Preview {
    CountdownTimer(
        totalTime: 60,
        isPaused: false,
        onTimeFinish: {
            
        }
    )
}*/

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
                Text("Listo!!")
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
            .onChange(of: timeUp) { oldValue, newValue in
                buttonEnabled = !newValue && spaces.isEmpty
            }
            .onChange(of: spaces) { oldValue, newValue in
                buttonEnabled = !timeUp && newValue.isEmpty
            }
        }
    }
}
