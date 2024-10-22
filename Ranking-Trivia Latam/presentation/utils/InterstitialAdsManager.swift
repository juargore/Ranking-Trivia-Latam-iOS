//
//  InterstitialAdsManager.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/18/24.
//

import Foundation
import GoogleMobileAds

class InterstitialAdsManager: NSObject, GADFullScreenContentDelegate, ObservableObject {
    
   @Published var interstitialAdLoaded:Bool = false
    var interstitialAd: GADInterstitialAd?
    
    var onAdClosed: (() -> Void)?
    
    override init() {
        super.init()
    }
    
    func loadInterstitialAd() {
        GADInterstitialAd.load(withAdUnitID: Constants.PLAY_FULL_SCREEN_BANNER_ID, request: GADRequest()) { [weak self] add, error in
            guard let self = self else {return}
            if let error = error{
                print("🔴: \(error.localizedDescription)")
                print("🔴: \(error)")
                self.interstitialAdLoaded = false
                onAdClosed?()
                return
            }
            print("🟢: Loading succeeded")
            self.interstitialAdLoaded = true
            self.interstitialAd = add
            self.interstitialAd?.fullScreenContentDelegate = self
        }
    }
    
    func displayInterstitialAd() {
        guard let windowScene = UIApplication.shared.connectedScenes
                .first as? UIWindowScene,
              let root = windowScene.windows.first?.rootViewController else {
            return
        }
        
        if let add = interstitialAd {
            add.present(fromRootViewController: root)
            self.interstitialAdLoaded = false
        } else {
            print("🔵: Ad wasn't ready")
            self.interstitialAdLoaded = false
            self.loadInterstitialAd()
        }
    }
    
    /*func displayInterstitialAd() {
        guard let root = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        if let add = interstitialAd{
            add.present(fromRootViewController: root)
            self.interstitialAdLoaded = false
        } else {
            print("🔵: Ad wasn't ready")
            self.interstitialAdLoaded = false
            self.loadInterstitialAd()
        }
    }*/
    
    // Failure notification
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("🟡: Failed to display interstitial ad")
        self.loadInterstitialAd()
    }
    
    // Indicate notification
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("🤩: Displayed an interstitial ad")
        self.interstitialAdLoaded = false
    }
    
    // Close notification
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("😔: Interstitial ad closed")
        onAdClosed?()
    }
}
