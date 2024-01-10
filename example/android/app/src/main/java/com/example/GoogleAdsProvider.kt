package com.example

import android.app.Activity
import android.content.Context
import android.util.Size
import com.google.android.gms.ads.AdError
import com.google.android.gms.ads.AdListener
import com.google.android.gms.ads.AdSize
import com.google.android.gms.ads.FullScreenContentCallback
import com.google.android.gms.ads.LoadAdError
import com.google.android.gms.ads.admanager.AdManagerAdRequest
import com.google.android.gms.ads.admanager.AdManagerAdView
import com.google.android.gms.ads.admanager.AdManagerInterstitialAd
import com.google.android.gms.ads.admanager.AdManagerInterstitialAdLoadCallback
import spotIm.common.ads.SPAdSize
import spotIm.common.ads.SPGoogleAdsBannerListener
import spotIm.common.ads.SPGoogleAdsInterstitialListener
import spotIm.common.ads.SPGoogleAdsProvider

class GoogleAdsProvider(override var spotId: String) : SPGoogleAdsProvider {
    private var adView: AdManagerAdView? = null
    private var adManagerInterstitialAd: AdManagerInterstitialAd? = null

    override fun hasInterstitialAd(): Boolean {
        return adManagerInterstitialAd != null
    }

    override fun loadBannerAd(
        appContext: Context,
        tag: String,
        sizes: Array<SPAdSize>,
        postId: String,
        listener: SPGoogleAdsBannerListener,
    ) {
        createGoogleBannerView(appContext, spAdSizesToGoogleAdSizes(sizes), tag)
        val adRequest = AdManagerAdRequest.Builder()
            .addCustomTargeting(BANNER_CONV_SDK_SPOT_ID, spotId)
            .build()
        adView?.loadAd(adRequest)
        adView?.adListener = object : AdListener() {
            override fun onAdLoaded() {
                adView?.let {
                    listener.onBannerLoaded(tag, it, Size(it.width, it.height))
                }
            }

            override fun onAdFailedToLoad(error: LoadAdError) {
                listener.onBannerFailedToLoad(error.message, error.code)
            }
        }
    }

    override fun loadInterstitialAd(
        appContext: Context,
        tag: String,
        postId: String,
        listener: SPGoogleAdsInterstitialListener,
    ) {
        val adRequest = AdManagerAdRequest.Builder()
            .addCustomTargeting(
                INTERSTITIAL_CONV_SDK_SPOT_ID,
                spotId,
            )
            .build()

        AdManagerInterstitialAd.load(
            appContext,
            tag,
            adRequest,
            object : AdManagerInterstitialAdLoadCallback() {
                override fun onAdLoaded(interstitialAd: AdManagerInterstitialAd) {
                    adManagerInterstitialAd = interstitialAd

                    adManagerInterstitialAd?.fullScreenContentCallback =
                        object : FullScreenContentCallback() {
                            override fun onAdDismissedFullScreenContent() {
                                adManagerInterstitialAd = null
                                listener.onAdDismissedFullScreenContent()
                            }

                            override fun onAdShowedFullScreenContent() {
                                listener.onAdShowedFullScreenContent()
                            }

                            override fun onAdFailedToShowFullScreenContent(adError: AdError) {
                                listener.onAdFailedToShowFullScreenContent(
                                    adError.message,
                                    adError.code,
                                )
                            }
                        }

                    listener.onInterstitialAdLoaded()
                }

                override fun onAdFailedToLoad(adError: LoadAdError) {
                    listener.onInterstitialAdFailedToLoad(adError.message, adError.code)
                }
            },
        )
    }

    override fun showInterstitialAd(activity: Activity) {
        adManagerInterstitialAd?.show(activity)
    }

    private fun spAdSizesToGoogleAdSizes(sizes: Array<SPAdSize>): Array<AdSize> {
        return sizes.map {
            when (it) {
                SPAdSize.BANNER -> AdSize.BANNER
                SPAdSize.FULL_BANNER -> AdSize.FULL_BANNER
                SPAdSize.LARGE_BANNER -> AdSize.LARGE_BANNER
                SPAdSize.LEADERBOARD -> AdSize.LEADERBOARD
                SPAdSize.MEDIUM_RECTANGLE -> AdSize.MEDIUM_RECTANGLE
                SPAdSize.WIDE_SKYSCRAPER -> AdSize.WIDE_SKYSCRAPER
            }
        }.toTypedArray()
    }

    private fun createGoogleBannerView(appContext: Context, sizes: Array<AdSize>, tag: String) {
        adView = AdManagerAdView(appContext)
        adView?.setAdSizes(*sizes)
        adView?.adUnitId = tag
    }

    companion object {
        private const val INTERSTITIAL_CONV_SDK_SPOT_ID = "interConvSdkSpotId"
        private const val BANNER_CONV_SDK_SPOT_ID = "bannerConvSdkSpotId"
    }
}
