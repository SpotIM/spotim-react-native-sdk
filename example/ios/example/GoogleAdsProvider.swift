//
//  GoogleAdsProvider.swift
//  Spot.IM-Core
//
//  Created by Eugene on 25.10.2019.
//  Copyright © 2019 Spot.IM. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SpotImCore

@objc final class GoogleAdsProvider: NSObject, AdsProvider {
    let bannerView: BaseView = .init()
    weak var bannerDelegate: AdsProviderBannerDelegate?
    weak var interstitialDelegate: AdsProviderInterstitialDelegate?
    
    private var banner: DFPBannerView?
    private var interstitial: DFPInterstitial?
    private var spotId: String = ""
    
    override init() {
        super.init()
    }
    
    @objc public class func setSpotImSDKWithProvider() {
      SpotIm.setGoogleAdsProvider(googleAdsProvider: GoogleAdsProvider())
    }
    
    func version() -> String { return "1.0" }
    
    func setSpotId(spotId: String) {
        self.spotId = spotId
    }
    
    func setupAdsBanner(with adId: String = Configuration.testBannerID, in controller: UIViewController, validSizes: Set<AdSize>) {
        var sizes: [NSValue] = validSizes.map { (size) -> NSValue in
            let gadSize = parseAdSizeToGADAdSize(adSize: size)
            return NSValueFromGADAdSize(gadSize)
        }
        
        if sizes.isEmpty {
            let defaultSize = parseAdSizeToGADAdSize(adSize: .small)
            sizes.append(NSValueFromGADAdSize(defaultSize))
        }
        
        banner = DFPBannerView()
        banner?.validAdSizes = sizes
        banner?.adUnitID = adId
        banner?.delegate = self
        banner?.rootViewController = controller
        let req = DFPRequest()
        req.customTargeting = ["bannerConvSdkSpotId":spotId]
        banner?.load(req)
    }
    
    func setupInterstitial(with adId: String = Configuration.testInterstitialID) {
        interstitial = DFPInterstitial(adUnitID: adId)
        interstitial?.delegate = self
        let req = DFPRequest()
        req.customTargeting = ["interConvSdkSpotId":spotId]
        interstitial?.load(req)
    }
    
    func showInterstitial(in controller: UIViewController) -> Bool {
        guard
            let interstitial = interstitial,
            interstitial.isReady
            else { return false }
        
        interstitial.present(fromRootViewController: controller)
        
        return true
    }
    
    private func parseAdSizeToGADAdSize(adSize: AdSize) -> GADAdSize {
        switch adSize {
        case .small:
            return kGADAdSizeBanner
        case .medium:
            return kGADAdSizeLargeBanner
        case .large:
            return kGADAdSizeMediumRectangle
        }
    }
}

extension GoogleAdsProvider: GADInterstitialDelegate {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        interstitialDelegate?.interstitialLoaded()
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitialDelegate?.interstitialDidDismiss()
    }
    
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        interstitialDelegate?.interstitialWillBeShown()
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        interstitialDelegate?.interstitialFailedToLoad(error: error)
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        interstitialDelegate?.interstitialDidDismiss()
    }
}

extension GoogleAdsProvider: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.bannerView.addSubview(bannerView)
        bannerView.centerXAnchor.constraint(equalTo: self.bannerView.centerXAnchor).isActive = true
        bannerView.centerYAnchor.constraint(equalTo: self.bannerView.centerYAnchor).isActive = true
        bannerDelegate?.bannerLoaded(adBannerSize: bannerView.adSize.size)
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        bannerDelegate?.bannerFailedToLoad(error: error)
    }
    
}

private extension GoogleAdsProvider {
    
    private enum Configuration {
        static let testInterstitialID: String = "/6499/example/interstitial"
        static let testBannerID: String = "/6499/example/banner"
    }
}
