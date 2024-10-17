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
    
    @State private var timeUp = false
    @State private var showTimeUpDialog = false
    @State private var showIncorrectDialog = false
    @State private var showCorrectDialog = false
    @State var draggedItem: TriviaFlag?
    
    init() {
        viewModel.getQuestionToPlay()
    }
    
    var body: some View {
        ZStack {
            PlayScreenBackground()
            
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
                    LazyVStack(spacing: 10) {
                        ForEach(Array(viewModel.spaces.enumerated()), id: \.offset) { i, item in
                            CardEmptySpace(index: i, emptySpace: item)
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
                                            print("AQUI: isOver: \(isOverSpace)")
                                            if viewModel.spaces[i].flag == nil {
                                                viewModel.spaces[i].flagIsOver = isOverSpace
                                            }
                                        }
                                    )
                                )
                        }
                    }
                
                    LazyVStack(spacing: 10) {
                        ForEach(Array(viewModel.flags.enumerated()), id: \.offset) { i, item in
                            if !item.alreadyPlayed {
                                CardFlag(flag: item)
                                    .onDrag {
                                        draggedItem = item
                                        return NSItemProvider(object: item)
                                    }
                                    //.opacity(draggedItem == item ? 0 : 1) // TODO: here
                            }
                        }
                    }
                }
                .padding(.horizontal, 196)
                
                Spacer()
            }
            
            VStack {
                Spacer()
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
                                print("AQUI: Correct")
                                // if (viewModel.shouldPlaySound()) playSound(context, R.raw.sound_success)
                                // animateScore = Triple(true, true, question!!)
                                vmh.incrementScore(viewModel.question!, isCorrect: true)
                                showCorrectDialog = true
                            } else {
                                print("AQUI: Incorrect")
                                //if (viewModel.shouldPlaySound()) playSound(context, R.raw.sound_error)
                                viewModel.incrementCounterOfErrors()
                                //animateScore = Triple(true, false, question!!)
                                vmh.incrementScore(viewModel.question!, isCorrect: false)
                                showIncorrectDialog = true
                            }
                        }
                    )
                    if viewModel.question != nil {
                        CountdownTimer(
                            totalTime: viewModel.getTimeAccordingLevel(level: viewModel.question!.level),
                            isPaused: (showCorrectDialog || showIncorrectDialog),
                            onTimeFinish: {
                                timeUp = true
                                showTimeUpDialog = true
                                //if (viewModel.shouldPlaySound()) playSound(context, R.raw.sound_error)
                                //animateScore = Triple(true, false, it)
                                vmh.incrementScore(viewModel.question!, isCorrect: false)
                                viewModel.incrementCounterOfErrors()
                            }
                        )
                    }
                    
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .popUpDialog(isShowing: $showTimeUpDialog, dialogContent: {
            TimeUpDialog(isVisible: showTimeUpDialog) {
                showTimeUpDialog = false
                presentationMode.wrappedValue.dismiss()
            }
        })
        .popUpDialog(isShowing: $showIncorrectDialog, dialogContent: {
            IncorrectDialog(isVisible: showIncorrectDialog) {
                showIncorrectDialog = false
            }
        })
        .popUpDialog(isShowing: $showCorrectDialog, dialogContent: {
            CorrectDialog(isVisible: showCorrectDialog) {
                showCorrectDialog = false
            }
        })
        .popUpDialog(isShowing: $viewModel.gameCompleted, dialogContent: {
            
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
        ZStack {
            Image(uiImage: UIImage(named: "pyramid_one")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VignetteInverseEffect()
        }
    }
}
