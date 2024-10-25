//
//  OptionsDialog.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import SwiftUI
import Foundation

struct OptionsDialog: View {
    
    var viewModel: HomeViewModel
    var onExitClicked: (String?) -> Void
    
    @State private var soundEnabled: Bool
    @State private var selectedLanguage: String? = nil
    
    let languages = [
        NSLocalizedString("options_english", comment: ""),
        NSLocalizedString("options_spanish", comment: ""),
        NSLocalizedString("options_portuguese", comment: "")
    ]
    
    init(
        viewModel: HomeViewModel,
        onExitClicked: @escaping (String?) -> Void
    ) {
        self.viewModel = viewModel
        self.onExitClicked = onExitClicked
        self.soundEnabled = viewModel.shouldPlaySound() ? true : false
    }
    
    var body: some View {
        BaseDialog(
            titleWidth: 150,
            title: NSLocalizedString("options_title", comment: ""),
            content: {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        Image("ic_settings")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .padding(.bottom, 5)
                        
                        Spacer(minLength: 10)
                        Toggle(
                            isOn: $soundEnabled
                        ) {
                            HStack {
                                Spacer()
                                
                                Image("ic_sound_ii")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .padding(.trailing, 10)
                                
                                Text(LocalizedStringKey("options_sound"))
                                    .font(.custom("FredokaCondensed-Bold", size: 28))
                                    .foregroundColor(.white)
                                    .shadow(color: .black, radius: 1, x: 0, y: 1)
                                    .padding(.trailing, 30)
                            }
                        }
                        .toggleStyle(SymbolToggleStyle(systemImage: "airplane", activeColor: Color.orange))

                        Spacer(minLength: 20)
                        
                        HStack {
                            Text(LocalizedStringKey("options_language"))
                                .font(.custom("FredokaCondensed-Bold", size: 28))
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 1, x: 0, y: 1)
                                .padding(.vertical, 6)
                            
                            Spacer()
                        }
                        
                        
                        RadioButtonLanguage(
                            items: languages,
                            selectedId: viewModel.getInitialOptionForRB(),
                            callback: { selected in
                                selectedLanguage = selected
                            }
                        )
                        
                        Spacer(minLength: 40)
                        
                        HStack {
                            ButtonExitOrRetry(
                                onClick: { onExitClicked(nil) },
                                content: {
                                    Text(LocalizedStringKey("general_exit"))
                                        .font(.custom("FredokaCondensed-Semibold", size: 22))
                                        .foregroundColor(.black)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 16)
                                }
                            )
                            ButtonExitOrRetry(
                                onClick: {
                                    viewModel.saveEnableSound(enable: soundEnabled)
                                    onExitClicked(selectedLanguage)
                                },
                                content: {
                                    Text(LocalizedStringKey("general_save"))
                                        .font(.custom("FredokaCondensed-Semibold", size: 22))
                                        .foregroundColor(.black)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 16)
                                }
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }
                .frame(height: 400)
            }
        )
        .onAppear {
            soundEnabled = viewModel.shouldPlaySound() ? true : false
        }
    }
}

struct ColorInvert: ViewModifier {

    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        Group {
            if colorScheme == .dark {
                content.colorInvert()
            } else {
                content
            }
        }
    }
}

struct RadioButton: View {

    @Environment(\.colorScheme) var colorScheme

    let id: String
    let callback: (String)->()
    let selectedID : String
    let size: CGFloat
    let color: Color
    let textSize: CGFloat

    init(
        _ id: String,
        callback: @escaping (String)->(),
        selectedID: String,
        size: CGFloat = 20,
        color: Color = Color.primary,
        textSize: CGFloat = 14
        ) {
        self.id = id
        self.size = size
        self.color = color
        self.textSize = textSize
        self.selectedID = selectedID
        self.callback = callback
    }

    var body: some View {
        Button(action:{
            self.callback(self.id)
        }) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: self.selectedID == self.id ? "largecircle.fill.circle" : "circle")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.size, height: self.size)
                    .modifier(ColorInvert())
                Text(id)
                    .font(.custom("FredokaCondensed-Bold", size: 22))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 1, x: 0, y: 1)
                Spacer()
            }.foregroundColor(self.color)
        }
        .foregroundColor(self.color)
    }
}

struct RadioButtonLanguage: View {

    let items: [String]

    @State var selectedId: String = ""

    let callback: (String) -> ()

    var body: some View {
        VStack {
            ForEach(0..<items.count) { index in
                RadioButton(
                    self.items[index],
                    callback: self.radioGroupCallback,
                    selectedID: self.selectedId
                )
            }
        }
    }

    func radioGroupCallback(id: String) {
        selectedId = id
        callback(id)
    }
}


#Preview {
    OptionsDialog(
        viewModel: HomeViewModel(),
        onExitClicked: { language in
            
        }
    )
}


struct SymbolToggleStyle: ToggleStyle {

    var systemImage: String = "checkmark"
    var activeColor: Color

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label

            Spacer()

            RoundedRectangle(cornerRadius: 30)
                .fill(configuration.isOn ? activeColor : Color.appDarkGrey)
                .overlay {
                    Circle()
                        .fill(configuration.isOn ? Color.green : Color.appLightGrey)
                        .padding(1)
                        .overlay {
                            Text(configuration.isOn ? LocalizedStringKey("options_on") : LocalizedStringKey("options_off"))
                                .font(.custom("FredokaCondensed-Bold", size: 22))
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 1, x: 0, y: 1)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 35)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .offset(x: configuration.isOn ? 13 : -13)

                }
                .overlay {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.black, lineWidth: 2)
                }
                .frame(width: 65, height: 38)
                .onTapGesture {
                    withAnimation(.spring()) {
                        configuration.isOn.toggle()
                    }
                }
        }
    }
}
