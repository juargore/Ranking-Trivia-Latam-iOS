//
//  HomeScreen.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import SwiftUI

struct HomeScreen: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    @State private var showOptionsDialog = false
    @State private var showAboutDialog = false
    @State private var showTutorialDialog = false
    @State private var showResetDialog = false
    
    @State private var selectedDestination: NavigationDestination?
    
    init(homeViewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = homeViewModel
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                HomeBackground()
                VStack {
                    VStack {
                        HomeLogoLetters()
                            .frame(maxWidth: .infinity, alignment: .top)
                        
                        HomeSideButtons(
                            viewModel: viewModel,
                            onSettingsClicked: { showOptionsDialog = true },
                            onAboutClicked: { showAboutDialog = true },
                            onTutorialClicked: { showTutorialDialog = true }
                        )
                        .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                        .padding(.horizontal, 180)
                    }
                    .frame(maxHeight: .infinity)
                    
                    VStack(
                        alignment: .center,
                        spacing: 20
                    ) {
                        NavigationLink(value: NavigationDestination.playScreen) {
                            HomeYellowButton(
                                viewModel: viewModel,
                                buttonType: .Start,
                                onClick: {
                                    if viewModel.userCompletedGame() {
                                        showResetDialog = true
                                    } else {
                                        selectedDestination = .playScreen
                                        print("=== AQUI: selectedDestination = \(selectedDestination)")
                                    }
                                }
                            ) {
                                Text("Iniciar")
                                    .font(.custom("FredokaCondensed-Semibold", size: 36))
                                    .shadow(color: .gray, radius: 2, x: 2, y: 2)
                                    .foregroundColor(Color.appDarkGrey)
                                    .padding(.vertical, 15)
                                    .padding(.horizontal, 60)
                            }
                        }
                        
                        NavigationLink(value: NavigationDestination.hallOfFameScreen) {
                            HomeYellowButton(
                                viewModel: viewModel,
                                buttonType: .HallOfFame,
                                onClick: {
                                    selectedDestination = .hallOfFameScreen
                                    print("=== AQUI: selectedDestination = \(selectedDestination)")
                                }
                            ) {
                                Text("Salón de la fama ✧✧")
                                    .font(.custom("FredokaCondensed-Semibold", size: 25))
                                    .shadow(color: .gray, radius: 1, x: 1, y: 1)
                                    .foregroundColor(Color.appDarkGrey)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 30)
                            }
                        }
                        //.frame(maxHeight: .infinity)
                        //.padding(.horizontal, 24)
                        //.frame(maxWidth: .infinity)
                        //.frame(maxHeight: .infinity)
                        .background(Color.red)
                    }
                }
                .padding(.horizontal, 24)
                .toolbar(.hidden, for: .navigationBar)
                .toolbar(.hidden, for: .tabBar)
            }
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .playScreen:
                    let _ = print("=== AQUI: Entró a .playScreen")
                    PlayScreen()
                case .hallOfFameScreen:
                    let _ = print("=== AQUI: Entró a .HallOfFameScreen")
                    HallOfFameScreen()
                case .homeScreen:
                    let _ = print("=== AQUI: Entró a .HomeScreen")
                    HomeScreen()
                }
            }
        }
    }
    
    struct HomeBackground: View {
        var body: some View {
            ZStack {
                Image(uiImage: UIImage(named: "pyramid_main_screen")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                VignetteInverseEffect()
                
                if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                   let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                    
                    // version = 1.0 && build = "1.0.1"
                    let _ = print("current version = \(version)")
                    HStack {
                        Text("v\(build)")
                            .font(.custom("FredokaCondensed-Semibold", size: 20))
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    }
                    .padding(.horizontal, 200)
                }
                
                /*
                 AdmobBanner(
                 modifier = modifierAdmob,
                 adId = HOME_BOTTOM_SMALL_BANNER_ID
                 )
                 */
                
            }
        }
    }
    
    
    struct HomeLogoLetters: View {
        var body: some View {
            Image("logo_no_background_letters")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 250)
                .frame(maxWidth: .infinity)
        }
    }
    
    struct HomeSideButtons: View {
        
        @State private var showNewerVersionButton = false
        
        var viewModel: HomeViewModel
        var onSettingsClicked: () -> Void
        var onAboutClicked: () -> Void
        var onTutorialClicked: () -> Void
        
        var body: some View {
            VStack {
                if showNewerVersionButton {
                    CircledButtonStart(buttonType: .NewVersion) {
                        //openUrl(urlString: GOOGLE_PLAY_GAME_URL)
                    }
                }
                CircledButtonStart(buttonType: .Settings) {
                    onSettingsClicked()
                }
                CircledButtonStart(buttonType: .About) {
                    onAboutClicked()
                }
                CircledButtonStart(buttonType: .Tutorial) {
                    onTutorialClicked()
                }
            }
            .onAppear {
                if let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    let versionComponents = versionString.split(separator: ".")
                    if let majorVersion = Int(versionComponents[0]) {
                        viewModel.gameHasNewerVersion(currentVersion: majorVersion, onResponse: { it in
                            showNewerVersionButton = it
                        })
                    }
                }
            }
        }
    }
    
    struct HomeYellowButton<Content: View>: View {
        
        @ObservedObject var viewModel: HomeViewModel
        
        var buttonType: HomeButtonType
        var playSound: Bool = true
        var onClick: () -> Void
        var content: () -> Content
        
        var body: some View {
            let width: CGFloat = (buttonType == .Start) ? 200 : 260
            let height: CGFloat = (buttonType == .Start) ? 70 : 60
            let buttonContent = ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.AppYellow.opacity(0.9))
                    .frame(width: width, height: height)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 3)
                    )
                    .onTapGesture {
                        print("==== AQUI: Click!")
                        onClick()
                        if playSound && viewModel.shouldPlaySound() {
                            Ranking_Trivia_Latam.playSound("sound_next_level")
                        }
                    }
                
                content()
            }
            
            VStack {
                if buttonType == .Start {
                    Pulsating(duration: 2.0, pulseFraction: 1.1) {
                        buttonContent
                    }
                } else {
                    buttonContent
                }
            }
        }
    }
    
    
    struct CircledButtonStart: View {
        var buttonType: HomeButtonType
        var onClick: () -> Void
        
        var body: some View {
            let boxContent: some View = Group {
                ZStack {
                    Circle()
                        .fill(Color.appCustomBlue.opacity(0.6))
                        .frame(width: 55, height: 55)
                        .onTapGesture {
                            onClick()
                        }
                        .overlay {
                            Image("ic_border_circled_button")
                                .resizable()
                                .padding(.leading, 30)
                                .padding(.top, 30)
                                .frame(width: 120, height: 120)
                        }
                    
                    switch buttonType {
                    case .Settings:
                        Image("ic_settings")
                            .resizable()
                            .scaledToFit()
                            .padding(10)
                    case .About:
                        Image("ic_info")
                            .resizable()
                            .scaledToFit()
                            .padding(10)
                    case .Tutorial:
                        Image("ic_question_no_border")
                            .resizable()
                            .scaledToFit()
                            .padding(5)
                    case .NewVersion:
                        Text("Nueva\nVersión")
                            .font(.custom("FredokaCondensed-Semibold", size: 12))
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.yellow)
                    case .Start:
                        Text("Start")
                    case .HallOfFame:
                        Text("Hall Of Fame")
                    }
                }
            }
            
            if buttonType == .NewVersion {
                Pulsating(duration: 1000, pulseFraction: 1.3) {
                    boxContent
                }
            } else {
                boxContent
            }
            
            Spacer().frame(height: 10)
        }
    }
    
    public enum HomeButtonType {
        case Start
        case Settings
        case About
        case Tutorial
        case NewVersion
        case HallOfFame
    }
    
    #Preview {
        HomeScreen()
    }
}
