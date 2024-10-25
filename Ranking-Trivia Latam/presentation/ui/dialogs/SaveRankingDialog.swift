//
//  SaveRankingDialog.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import SwiftUI

struct SaveRankingDialog: View {
    
    let viewModel: HallOfFameViewModel
    var onSavedSuccess: () -> Void
    var onDismiss: () -> Void
    
    @State private var showToast = false
    @State private var messageToast = ""
    @State private var isShowingScroll = false
    @State private var mWord: String = ""
    @State private var triviaFlag: TriviaFlag? = nil
    
    var body: some View {
        BaseDialog(
            titleWidth: 180,
            title: NSLocalizedString("new_record_title", comment: ""),
            content: {
                VStack {
                    ScoreUI(score: viewModel.getTotalScore())
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        Text(NSLocalizedString("new_record_description_top", comment: ""))
                            .font(.custom("FredokaCondensed-Semibold", size: 18))
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .lineSpacing(2)
                        
                        TextFieldTrivia(
                            allFlags: viewModel.getAllTriviaFlags(),
                            onWordChange: { newWord in
                                mWord = newWord
                            },
                            onFlagSelected: { selectedFlag in
                                triviaFlag = selectedFlag
                            },
                            isShowingScroll: { showing in
                                isShowingScroll = showing
                            }
                        )
                        
                        if !isShowingScroll {
                            Text(NSLocalizedString("new_record_description_bottom", comment: ""))
                                .font(.custom("FredokaCondensed-Semibold", size: 18))
                                .foregroundColor(Color.black)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .lineSpacing(2)
                        }
                        
                        
                        Spacer(minLength: 15)
                        
                        ButtonExitOrRetry(
                            onClick: {
                                checkInternetConnection(
                                    isConnected: { connected in
                                        if connected {
                                            if !mWord.isEmpty {
                                                if triviaFlag != nil {
                                                    viewModel.saveNewRecord(flag: triviaFlag!, name: mWord)
                                                    onSavedSuccess()
                                                } else {
                                                    messageToast = NSLocalizedString("new_record_select_flag", comment: "")
                                                    showToast = true
                                                }
                                            } else {
                                                messageToast = NSLocalizedString("new_record_write_a_name", comment: "")
                                                showToast = true
                                            }
                                        } else {
                                            messageToast = NSLocalizedString("new_record_need_internet", comment: "")
                                            showToast = true
                                        }
                                    }
                                )
                            },
                            content: {
                                Text(NSLocalizedString("new_record_save", comment: ""))
                                    .font(.custom("FredokaCondensed-Semibold", size: 22))
                                    .foregroundColor(.black)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 16)
                            }
                        )
                    }
                    .frame(height: 400)
                }
                .padding(.horizontal, 10)
            }
        )
        .toast(message: messageToast, isShowing: $showToast, duration: Toast.short)
    }
}

struct ScoreUI: View {
    
    let score: Int
    let sizes: [CGFloat] = [20, 26, 30, 26, 20]
    
    var scoreString: String {
        NumberFormatter.localizedString(from: NSNumber(value: score), number: .decimal)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.red.opacity(0.9))
                .frame(width: 55, height: 55)
                .onTapGesture {
                    //onClick()
                }
                .overlay {
                    Image("ic_border_circled_button")
                        .resizable()
                        .padding(.leading, 30)
                        .padding(.top, 30)
                        .frame(width: 120, height: 120)
                }
            
            HStack(spacing: 0) {
                ForEach(Array(scoreString.enumerated()), id: \.offset) { index, char in
                    let fontSize = sizes[index % sizes.count]
                    Text(String(char))
                        .font(.custom("FredokaCondensed-Semibold", size: fontSize))
                        .shadow(color: .gray, radius: 1, x: 1, y: 1)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .frame(height: 60)
    }
}


#Preview {
    SaveRankingDialog(
        viewModel: HallOfFameViewModel(),
        onSavedSuccess: { },
        onDismiss: { }
    )
}

struct TextFieldTrivia: View {
    
    let allFlags: [TriviaFlag]
    @State private var word = ""

    var onWordChange: (String) -> Void
    var onFlagSelected: (TriviaFlag) -> Void
    var isShowingScroll: (Bool) -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            FlagsDropDownMenu(
                allFlags: allFlags,
                onFlagSelected: { flag in
                    onFlagSelected(flag)
                },
                isShowingScroll: { showing in
                    isShowingScroll(showing)
                }
            )
            .frame(width: 100, height: 50)

            TextField("", text: $word)
                .onChange(of: word) { new in
                    onWordChange(new)
                }
            .font(.custom("FredokaCondensed-Medium", size: 18))
            .padding()
            .frame(height: 50)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 2))
        }
        .padding(.vertical, 15)
    }
}


struct FlagsDropDownMenu: View {
    
    let allFlags: [TriviaFlag]

    var onFlagSelected: (TriviaFlag) -> Void
    var isShowingScroll: (Bool) -> Void
    
    @State private var expanded = false
    @State private var selectedImage: String

    init(
        allFlags: [TriviaFlag],
        onFlagSelected: @escaping (TriviaFlag) -> Void,
        isShowingScroll: @escaping (Bool) -> Void
    ) {
        self.allFlags = allFlags
        self.onFlagSelected = onFlagSelected
        self.isShowingScroll = isShowingScroll
        _selectedImage = State(initialValue: allFlags.first?.image ?? "")
    }

    var body: some View {
        VStack(alignment: .leading) {
            if !expanded {
                Button(action: {
                    expanded.toggle()
                }) {
                    Image(selectedImage)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
                .background(Color.white)
                .cornerRadius(25)
            }
            
            if expanded {
                ScrollView {
                    LazyVStack {
                        ForEach(allFlags, id: \.self) { flag in
                            Button(action: {
                                onFlagSelected(flag)
                                selectedImage = flag.image
                                expanded = false
                            }) {
                                Image(flag.image)
                                    .resizable()
                                    .frame(width: 45, height: 45)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .padding(.vertical, 2)
                            }
                        }
                    }
                    .padding(.bottom, 180)
                    .padding(.top, 100)
                }
                .background(Color.blue)
                .frame(width: 100, height: 500)
            }
        }
        .padding()
        .onChange(of: expanded) { new in
            isShowingScroll(new)
        }
    }
}
