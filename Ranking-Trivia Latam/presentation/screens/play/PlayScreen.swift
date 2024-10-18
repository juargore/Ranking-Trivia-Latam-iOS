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
    @State private var animateScore: AnimatedScoreData? = nil
    
    @State var draggedItem: TriviaFlag?
    @State var draggedOffset: CGSize = .zero
    @State var dragPosition: CGPoint = .zero
    
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
                            level: viewModel.question!.level,
                            question: viewModel.question!.description,
                            onBack: {
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                    }
                    
                    HStack {
                        // Columna izquierda: Empty Spaces
                        //ScrollView {
                            LazyVStack(alignment: .center, spacing: 10) {
                                ForEach(Array(viewModel.spaces.enumerated()), id: \.offset) { i, item in
                                    CardEmptySpace(
                                        index: i,
                                        emptySpace: item,
                                        viewModel: viewModel
                                    )
                                    
                                    /*.onDrop(
                                        of: [.text],
                                        delegate: EmptySpaceDropDelegate(
                                            draggedItem: $draggedItem,
                                            onFinished: { triviaFlag in
                                                if viewModel.spaces[i].flag == nil {
                                                    viewModel.spaces[i].flag = triviaFlag
                                                    
                                                    for rItem in viewModel.flags {
                                                        if rItem.name == triviaFlag.name {
                                                            rItem.alreadyPlayed = true
                                                            return
                                                        }
                                                    }
                                                }
                                            },
                                            viewIsOverSpace: { isOverSpace in
                                                if viewModel.spaces[i].flag == nil {
                                                    viewModel.spaces[i].flagIsOver = isOverSpace
                                                }
                                            }
                                        )
                                    )*/
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        //}
                        //.frame(width: UIScreen.screenWidth * 0.6)
                        //.border(Color.white, width: 4)
                        
                        // Columna derecha: Flags
                        //ScrollView {
                            LazyVStack(alignment: .center, spacing: 10) {
                                ForEach(Array(viewModel.flags.enumerated()), id: \.offset) { i, item in
                                    if !item.alreadyPlayed {
                                        CardFlag(flag: item)
                                            .offset(draggedItem == item ? draggedOffset : .zero)
                                            .gesture(
                                                DragGesture()
                                                    .onChanged { value in
                                                        draggedItem = item
                                                        draggedOffset = value.translation
                                                        dragPosition = CGPoint(
                                                            x: value.location.x + draggedOffset.width,
                                                            y: value.location.y + draggedOffset.height
                                                        )
                                                        checkIfOverEmptySpace()
                                                    }
                                                    .onEnded { _ in
                                                        if let targetIndex = viewModel.spaces.firstIndex(where: { $0.flagIsOver }) {
                                                            if viewModel.spaces[targetIndex].flag == nil {
                                                                viewModel.spaces[targetIndex].flag = draggedItem
                                                                viewModel.flags[i].alreadyPlayed = true
                                                            }
                                                        }
                                                        draggedItem = nil
                                                        draggedOffset = .zero
                                                    }
                                            )
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        //}
                        //.frame(width: UIScreen.screenWidth * 0.4)
                        //.border(Color.black, width: 3)
                    }
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
                    .border(Color.black, width: 1)
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: UIScreen.screenHeight * 0.7
                )
                Spacer()
            }
            .frame(maxWidth: UIScreen.screenWidth, maxHeight: UIScreen.screenHeight)

            
            /*VStack {
                VStack {
                    if viewModel.question != nil {
                        PlayScreenHeader(
                            level: viewModel.question!.level,
                            question: viewModel.question!.description,
                            onBack: {
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                    }
                    
                    HStack {
                        ScrollView {
                            LazyVStack(alignment: .center, spacing: 10) {
                                ForEach(Array(viewModel.spaces.enumerated()), id: \.offset) { i, item in
                                    CardEmptySpace(
                                        index: i,
                                        emptySpace: item,
                                        viewModel: viewModel
                                    )
                                    .onDrop(
                                        of: [.text],
                                        delegate: EmptySpaceDropDelegate(
                                            draggedItem: $draggedItem,
                                            onFinished: { triviaFlag in
                                                if viewModel.spaces[i].flag == nil {
                                                    viewModel.spaces[i].flag = triviaFlag
                                                    
                                                    for rItem in viewModel.flags {
                                                        if rItem.name == triviaFlag.name {
                                                            rItem.alreadyPlayed = true
                                                            return
                                                        }
                                                    }
                                                }
                                            },
                                            viewIsOverSpace: { isOverSpace in
                                                //print("AQUI: isOver: \(isOverSpace)")
                                                if viewModel.spaces[i].flag == nil {
                                                    viewModel.spaces[i].flagIsOver = isOverSpace
                                                }
                                            }
                                        )
                                    )
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                        .frame(width: UIScreen.screenWidth * 0.6)
                        .border(Color.white, width: 4)
                        
                        ScrollView {
                            LazyVStack(alignment: .center, spacing: 10) {
                                ForEach(Array(viewModel.flags.enumerated()), id: \.offset) { i, item in
                                    if !item.alreadyPlayed {
                                        // TODO: Aqui!!!
                                        CardFlag(flag: item)
                                            .offset(draggedItem == item ? draggedOffset : .zero)
                                            .gesture(
                                                DragGesture()
                                                    .onChanged { value in
                                                        draggedItem = item
                                                        draggedOffset = value.translation
                                                        dragPosition = CGPoint(
                                                            x: value.location.x + draggedOffset.width,
                                                            y: value.location.y + draggedOffset.height
                                                        )
                                                        checkIfOverEmptySpace()
                                                    }
                                                    .onEnded { _ in
                                                        if let targetIndex = viewModel.spaces.firstIndex(where: { $0.flagIsOver }) {
                                                            viewModel.spaces[targetIndex].flag = draggedItem
                                                            viewModel.flags[i].alreadyPlayed = true
                                                        }
                                                        draggedItem = nil
                                                        draggedOffset = .zero
                                                    }
                                            )
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .border(Color.pink, width: 4)
                        }
                        .frame(width: UIScreen.screenWidth * 0.4)
                        .border(Color.black, width: 3)
                    }
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
                    .border(Color.black, width: 1)
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: UIScreen.screenHeight * 0.7
                )
                Spacer()
            }
            .frame(maxWidth: UIScreen.screenWidth, maxHeight: UIScreen.screenHeight)
            */
            
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
                                if responseIsCorrect {
                                    if viewModel.shouldPlaySound() {
                                        Ranking_Trivia_Latam.playSound("sound_success")
                                    }
                                    animateScore = AnimatedScoreData(visible: true, isCorrect: true, question: viewModel.question!)
                                    vmh.incrementScore(viewModel.question!, isCorrect: true)
                                    showCorrectDialog = true
                                } else {
                                    print("AQUI: Incorrect")
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
                                totalTime: viewModel.timePerLevel,
                                isPaused: (showCorrectDialog || showIncorrectDialog),
                                onTimeFinish: {
                                    timeUp = true
                                    showTimeUpDialog = true
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
        .disabled(!interstitialAdManager.interstitialAdLoaded)
        .popUpDialog(isShowing: $showTimeUpDialog, dialogContent: {
            TimeUpDialog(isVisible: showTimeUpDialog) {
                if viewModel.shouldDisplayAd() {
                    interstitialAdManager.displayInterstitialAd()
                    interstitialAdManager.onAdClosed = {
                        viewModel.resetErrors()
                        viewModel.resetScreenData()
                        showTimeUpDialog = false
                    }
                } else {
                    viewModel.resetScreenData()
                    showTimeUpDialog = false
                }
            }
        })
        .popUpDialog(isShowing: $showIncorrectDialog, dialogContent: {
            IncorrectDialog(isVisible: showIncorrectDialog) {
                if viewModel.shouldDisplayAd() {
                    interstitialAdManager.displayInterstitialAd()
                    interstitialAdManager.onAdClosed = {
                        viewModel.resetErrors()
                        viewModel.resetScreenData()
                        showIncorrectDialog = false
                    }
                } else {
                    viewModel.resetScreenData()
                    showIncorrectDialog = false
                }
            }
        })
        .popUpDialog(isShowing: $showCorrectDialog, dialogContent: {
            CorrectDialog(isVisible: showCorrectDialog) {
                viewModel.saveQuestionAlreadyPlayed(question: viewModel.question!)
                viewModel.resetScreenData()
                showCorrectDialog = false
            }
        })
        .popUpDialog(isShowing: $viewModel.gameCompleted, dialogContent: {
            
        })
    }
    
    func checkIfOverEmptySpace() {
        for i in viewModel.spaces.indices {
            if let frame = viewModel.spaces[i].frame, frame.contains(dragPosition) {
                print("AQUI: flagIsOver = true")
                viewModel.spaces[i].flagIsOver = true
            } else {
                print("AQUI: flagIsOver = false")
                viewModel.spaces[i].flagIsOver = false
            }
        }
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

/*struct PlayScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var dragInfo = DragTargetInfo()
    
    @State private var leftItems: [EmptySpace] = [
        EmptySpace(id: 0, flag: nil),
        EmptySpace(id: 1, flag: nil),
        EmptySpace(id: 2, flag: nil)
    ]
    
    @State private var rightItems: [TriviaFlag] = [
        TriviaFlag(id: .AR, name: NSLocalizedString("country_name_argentina", comment: ""), image: "flag_argentina", alreadyPlayed: false),
        TriviaFlag(id: .BZ, name: NSLocalizedString("country_name_belize", comment: ""), image: "flag_belize", alreadyPlayed: false),
        TriviaFlag(id: .BO, name: NSLocalizedString("country_name_bolivia", comment: ""), image: "flag_bolivia", alreadyPlayed: false),
        TriviaFlag(id: .BR, name: NSLocalizedString("country_name_brasil", comment: ""), image: "flag_brasil", alreadyPlayed: false)
    ]
    
    @State var draggedItem: TriviaFlag?
    @State var draggedOffset: CGSize = .zero
    @State var dragPosition: CGPoint = .zero
    
    var body: some View {
        ZStack {
            PlayScreenBackground()
            
            VStack {
                HeaderBackAndCategory {
                    presentationMode.wrappedValue.dismiss()
                }
                
                HStack {
                    // Left side where the items will be dropped
                    LazyVStack(spacing: 10) {
                        ForEach(Array(leftItems.enumerated()), id: \.offset) { i, item in
                            GeometryReader { geometry in
                                CardEmptySpace(index: i, emptySpace: item)
                                    .onAppear {
                                        leftItems[i].frame = geometry.frame(in: .global)
                                    }
                            }
                            .frame(height: 120)
                        }
                    }
                
                    // Right side with draggable flags
                    LazyVStack(spacing: 10) {
                        ForEach(Array(rightItems.enumerated()), id: \.offset) { i, item in
                            if !item.alreadyPlayed {
                                CardFlag(flag: item)
                                    .offset(draggedItem == item ? draggedOffset : .zero)
                                    .gesture(
                                        DragGesture()
                                            .onChanged { value in
                                                draggedItem = item
                                                draggedOffset = value.translation
                                                dragPosition = CGPoint(
                                                    x: value.location.x + draggedOffset.width,
                                                    y: value.location.y + draggedOffset.height
                                                )
                                                checkIfOverEmptySpace()
                                            }
                                            .onEnded { _ in
                                                if let targetIndex = leftItems.firstIndex(where: { $0.flagIsOver }) {
                                                    leftItems[targetIndex].flag = draggedItem
                                                    rightItems[i].alreadyPlayed = true
                                                }
                                                draggedItem = nil
                                                draggedOffset = .zero
                                            }
                                    )
                            }
                        }
                    }
                }
                Spacer()
            }
            .toolbar(.hidden, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
            .padding(.horizontal, 196)
        }
    }
    
    func checkIfOverEmptySpace() {
        for i in leftItems.indices {
            if let frame = leftItems[i].frame, frame.contains(dragPosition) {
                leftItems[i].flagIsOver = true
            } else {
                leftItems[i].flagIsOver = false
            }
        }
    }
}*/


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

/*#Preview {
    PlayScreen()
}*/


/*
 CHIDO:
 CardFlag(flag: item)
     /*.onDrag {
         draggedItem = item
         return NSItemProvider(object: item)
     }*/
     //.opacity(draggedItem == item ? 0 : 1) // TODO: here
 */
