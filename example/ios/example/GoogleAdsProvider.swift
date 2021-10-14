//
//  GoogleAdsProvider.swift
//  Spot-IM.Development
//
//  Created by Alon Shprung on 24/08/2021.
//  Copyright © 2021 Spot.IM. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SpotImCore

final class GoogleAdsProvider: NSObject, AdsProvider {
    weak var bannerDelegate: AdsProviderBannerDelegate?
    weak var interstitialDelegate: AdsProviderInterstitialDelegate?

    private var banner: GAMBannerView?
    private var interstitial: GAMInterstitialAd?
    private var spotId: String = ""

    override init() {
        super.init()
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

        banner = GAMBannerView()
        banner?.validAdSizes = sizes
        banner?.adUnitID = adId
        banner?.delegate = self
        banner?.rootViewController = controller
        let req = GAMRequest()
        req.customTargeting = ["bannerConvSdkSpotId":spotId]
        banner?.load(req)
    }

    func setupInterstitial(with adId: String = Configuration.testInterstitialID) {
        let req = GAMRequest()
        req.customTargeting = ["interConvSdkSpotId":spotId]

        GAMInterstitialAd.load(withAdManagerAdUnitID: adId, request: req) { ad, error in
            if let error = error {
                self.interstitialDelegate?.interstitialFailedToLoad(error: error)
                return
            }
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
            self.interstitialDelegate?.interstitialLoaded()
        }
    }

    func showInterstitial(in controller: UIViewController) -> Bool {
        guard let interstitial = interstitial else { return false }

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
  
    @objc public class func setSpotImSDKWithProvider() {
      SpotIm.setGoogleAdsProvider(googleAdsProvider: GoogleAdsProvider())
    }
}

extension GoogleAdsProvider: GADFullScreenContentDelegate {
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        interstitialDelegate?.interstitialWillBeShown()
    }

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        interstitialDelegate?.interstitialDidDismiss()
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        interstitialDelegate?.interstitialDidDismiss()
    }
}

extension GoogleAdsProvider: GADBannerViewDelegate {

    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerDelegate?.bannerLoaded(bannerView: bannerView, adBannerSize: bannerView.adSize.size, adUnitID: bannerView.adUnitID ?? "")
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        bannerDelegate?.bannerFailedToLoad(error: error)
    }
}

private extension GoogleAdsProvider {

    private enum Configuration {
        static let testInterstitialID: String = "/6499/example/interstitial"
        static let testBannerID: String = "/6499/example/banner"
    }
}
