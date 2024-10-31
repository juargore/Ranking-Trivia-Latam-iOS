//
//  PlayScreen.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct PlayScreen: View {
    
    @ObservedObject var viewModel = PlayViewModel()
    @ObservedObject var vmh = HallOfFameViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var dragInfo = DragTargetInfo()
    @StateObject private var interstitialAdManager = InterstitialAdsManager()
    
    @State private var timeUp = false
    @State private var showTimeUpDialog = false
    @State private var showIncorrectDialog = false
    @State private var showCorrectDialog = false
    @State private var showHintDescriptionDialog = false
    @State private var animateScore: AnimatedScoreData? = nil
    
    @State private var showToast = false
    @State private var messageToast = ""
    
    @State var draggedItem: TriviaFlag?
    @State var draggedOffset: CGSize = .zero
    @State var dragPosition: CGPoint = .zero
    @State var selectedFlag: TriviaFlag? = nil
    
    init() {
        viewModel.getQuestionToPlay()
    }
    
    var body: some View {
        ZStack {
            PlayScreenBackground()
            
            VStack {
                VStack {
                    if viewModel.question != nil {
                        PlayScreenHeader(
                            viewModel: viewModel,
                            level: viewModel.question!.level,
                            question: viewModel.question!.description,
                            isHintEnabled: viewModel.flags.contains { !$0.showPosition },
                            onHintClicked: {
                                if viewModel.shouldShowHintDialog() {
                                    showHintDescriptionDialog = true
                                } else {
                                    interstitialAdManager.displayInterstitialAd()
                                    interstitialAdManager.onAdClosed = {
                                        viewModel.discoverPositionOnFlag()
                                    }
                                }
                            },
                            onBack: {
                                viewModel.resetScreenData(getNewQuestion: false)
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                    }
                    
                    HStack {
                        // left column: Empty Spaces
                        ScrollView {
                            LazyVStack(alignment: .center, spacing: 10) {
                                ForEach(Array(viewModel.spaces.enumerated()), id: \.offset) { i, item in
                                    CardEmptySpace(
                                        index: i,
                                        emptySpace: item,
                                        viewModel: viewModel
                                    )
                                    .onTapGesture {
                                        if selectedFlag != nil && item.flag == nil {
                                            viewModel.spaces[i].flag = selectedFlag
                                            if let flagIndex = viewModel.flags.firstIndex(where: { $0.id == selectedFlag!.id }) {
                                                viewModel.flags[flagIndex].alreadyPlayed = true
                                            }
                                            if viewModel.shouldPlaySound() {
                                                Ranking_Trivia_Latam.playSound("sound_click")
                                            }
                                            selectedFlag = nil
                                            
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding(.top, 10)
                        }
                        .frame(maxWidth: UIScreen.screenWidth * 0.6)
                        
                        
                        // right column: Flags
                        ScrollView {
                            LazyVStack(alignment: .center, spacing: 10) {
                                ForEach(Array(viewModel.flags.enumerated()), id: \.offset) { i, item in
                                    if !item.alreadyPlayed {
                                        CardFlag(flag: item)
                                            .onTapGesture {
                                                if item.isEnable {
                                                    var newFlags: [TriviaFlag] = []
                                                    for f in viewModel.flags {
                                                        let nFlag = TriviaFlag(
                                                            id: f.id,
                                                            name: f.name,
                                                            image: f.image,
                                                            alreadyPlayed: f.alreadyPlayed,
                                                            isClicked: false,
                                                            isEnable: f.isEnable,
                                                            position: f.position,
                                                            showPosition: f.showPosition
                                                        )
                                                        newFlags.append(nFlag)
                                                    }
                                                    viewModel.flags = newFlags
                                                    
                                                    let mFlag = viewModel.flags[i]
                                                    viewModel.flags[i] = TriviaFlag(
                                                        id: mFlag.id,
                                                        name: mFlag.name,
                                                        image: mFlag.image,
                                                        isClicked: true,
                                                        position: mFlag.position,
                                                        showPosition: mFlag.showPosition
                                                    )
                                                    selectedFlag = item
                                                }
                                            }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding(.top, 10)
                        }
                        .frame(maxWidth: UIScreen.screenWidth * 0.4)
                        
                    }
                    .frame(
                        maxWidth: UIScreen.screenWidth,
                        maxHeight: .infinity
                    )
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: UIScreen.screenHeight * 0.7
                )
                Spacer()
            }
            .frame(maxWidth: UIScreen.screenWidth, maxHeight: UIScreen.screenHeight)

            
            VStack {
                Spacer()
                VStack {
                    HStack {
                        BottomButton(
                            timeUp: timeUp,
                            spaces: viewModel.spaces.filter { $0.flag == nil },
                            onClick: {
                                let responseIsCorrect = viewModel.verifyIfListIsCorrect(
                                    userResponse: viewModel.spaces.map { $0.flag!.id },
                                    question: viewModel.question!
                                )
                                viewModel.resetTime()
                                if responseIsCorrect {
                                    if viewModel.shouldPlaySound() {
                                        Ranking_Trivia_Latam.playSound("sound_success")
                                    }
                                    animateScore = AnimatedScoreData(visible: true, isCorrect: true, question: viewModel.question!)
                                    vmh.incrementScore(viewModel.question!, isCorrect: true)
                                    showCorrectDialog = true
                                } else {
                                    if viewModel.shouldPlaySound() {
                                        Ranking_Trivia_Latam.playSound("sound_error")
                                    }
                                    viewModel.incrementCounterOfErrors()
                                    animateScore = AnimatedScoreData(visible: true, isCorrect: false, question: viewModel.question!)
                                    vmh.incrementScore(viewModel.question!, isCorrect: false)
                                    showIncorrectDialog = true
                                }
                            }
                        )
                        if viewModel.question != nil {
                            CountdownTimer(
                                totalTime: Int(viewModel.timePerLevel),
                                isPaused: (showCorrectDialog || showIncorrectDialog || showTimeUpDialog),
                                onTimeFinish: {
                                    timeUp = true
                                    showTimeUpDialog = true
                                    viewModel.resetTime()
                                    if viewModel.shouldPlaySound() {
                                        Ranking_Trivia_Latam.playSound("sound_error")
                                    }
                                    animateScore = AnimatedScoreData(visible: true, isCorrect: false, question: viewModel.question!)
                                    vmh.incrementScore(viewModel.question!, isCorrect: false)
                                    viewModel.incrementCounterOfErrors()
                                }
                            )
                            .padding(.horizontal, 16)
                        }
                        
                        ZStack {
                            ScoreUI(score: vmh.getTotalScore())
                            if let sc = animateScore {
                                AnimateScoreNumber(visible: sc.visible, score: vmh.getPointsToAnimate(sc.question, sc.isCorrect))
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    
                    AdmobBanner(adUnitID: Constants.PLAY_BOTTOM_SMALL_BANNER_ID)
                        .frame(height: 50)
                        .padding(.top, 10)
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: UIScreen.screenHeight * 0.2
                )
            }
            .frame(maxWidth: UIScreen.screenWidth, maxHeight: UIScreen.screenHeight)
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .onAppear{
            interstitialAdManager.loadInterstitialAd()
        }
        .toast(message: messageToast, isShowing: $showToast, duration: Toast.short)
        .popUpDialog(isShowing: $showTimeUpDialog, dialogContent: {
            TimeUpDialog(isVisible: showTimeUpDialog) {
                if viewModel.shouldDisplayAd() {
                    interstitialAdManager.displayInterstitialAd()
                    interstitialAdManager.onAdClosed = {
                        viewModel.resetErrors()
                        viewModel.resetScreenData(getNewQuestion: true)
                        showTimeUpDialog = false
                        timeUp = false
                    }
                } else {
                    viewModel.resetScreenData(getNewQuestion: true)
                    showTimeUpDialog = false
                    timeUp = false
                }
            }
        })
        .popUpDialog(isShowing: $showIncorrectDialog, dialogContent: {
            IncorrectDialog(isVisible: showIncorrectDialog) {
                if viewModel.shouldDisplayAd() {
                    interstitialAdManager.displayInterstitialAd()
                    interstitialAdManager.onAdClosed = {
                        viewModel.resetErrors()
                        viewModel.resetScreenData(getNewQuestion: true)
                        showIncorrectDialog = false
                    }
                } else {
                    viewModel.resetScreenData(getNewQuestion: true)
                    showIncorrectDialog = false
                }
            }
        })
        .popUpDialog(isShowing: $showCorrectDialog, dialogContent: {
            CorrectDialog(isVisible: showCorrectDialog) {
                viewModel.saveQuestionAlreadyPlayed(question: viewModel.question!)
                viewModel.resetScreenData(getNewQuestion: true)
                showCorrectDialog = false
            }
        })
        .popUpDialog(isShowing: $viewModel.gameCompleted, dialogContent: {
            SaveRankingDialog(
                viewModel: vmh,
                onSavedSuccess: {
                    messageToast = "Guardando récord..."
                    showToast = true
                    presentationMode.wrappedValue.dismiss()
                },
                onDismiss: {
                    viewModel.gameCompleted = false
                }
            )
        })
        .popUpDialog(isShowing: $showHintDescriptionDialog, dialogContent: {
            HintDescriptionDialog(
                onAcceptClicked: { checked in
                    showHintDescriptionDialog = false
                    interstitialAdManager.displayInterstitialAd()
                    interstitialAdManager.onAdClosed = {
                        if checked {
                            viewModel.saveShouldShowHintDialog(false)
                        }
                        viewModel.discoverPositionOnFlag()
                    }
                },
                onCancelClicked: {
                    showHintDescriptionDialog = false
                }
            )
        })
    }
    
    struct EmptySpaceDropDelegate: DropDelegate {
        
        @Binding var draggedItem: TriviaFlag?
        
        var onFinished: (TriviaFlag) -> Void
        var viewIsOverSpace: (Bool) -> Void
        
        func performDrop(info: DropInfo) -> Bool {
            guard let item = draggedItem else { return false }
            
            onFinished(item)
            draggedItem = nil
            
            return true
        }
        
        func dropEntered(info: DropInfo) {
            viewIsOverSpace(true)
        }
        
        func dropUpdated(info: DropInfo) -> DropProposal? {
            return DropProposal(operation: .move)
        }
        
        func dropExited(info: DropInfo) {
            viewIsOverSpace(false)
        }
    }
}

struct PlayScreenBackground: View {
    var body: some View {
        Image(uiImage: UIImage(named: "pyramid_one")!)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
        
        VignetteInverseEffect()
    }
}

struct AnimateScoreNumber: View {
    
    let visible: Bool
    let score: Int
    let animationDuration: Double = 2.0
    
    @State private var offsetY: CGFloat = 0
    @State private var opacity: Double = 1.0
    
    var body: some View {
        if visible {
            let scoreString = score > 0 ? "+\(score)" : "\(score)"
            let scoreColor = score > 0 ? Color.white : Color.red
            
            Text(scoreString)
                .font(.system(size: 30, weight: .bold, design: .default))
                .foregroundColor(scoreColor)
                .shadow(color: .black, radius: 5, x: 2, y: 2)
                .offset(y: offsetY)
                .opacity(opacity)
                .onAppear {
                    withAnimation(Animation.easeOut(duration: animationDuration)) {
                        offsetY = -150
                    }
                    withAnimation(Animation.linear(duration: animationDuration)) {
                        opacity = 0
                    }
                }
        }
    }
}

#Preview {
    PlayScreen()
}
