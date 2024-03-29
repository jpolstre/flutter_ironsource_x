import 'package:flutter/material.dart';
import 'package:flutter_ironsource_x/ironsource.dart';
import 'package:flutter_ironsource_x/models.dart';
import 'package:flutter_ironsource_x_example/providers/banner_providers.dart';

import 'custom_button.dart';

class ButtonAdsWidgetAndInitIronSource extends StatefulWidget {
  final BannerProvider bannerProvider;
  const ButtonAdsWidgetAndInitIronSource(
      {Key? key, required this.bannerProvider})
      : super(key: key);

  @override
  State<ButtonAdsWidgetAndInitIronSource> createState() =>
      _ButtonAdsWidgetAndInitIronSourceState();
}

class _ButtonAdsWidgetAndInitIronSourceState
    extends State<ButtonAdsWidgetAndInitIronSource>
    with IronSourceListener, WidgetsBindingObserver {
  final String appKey =
      "85460dcd"; // "85460dcd"; // change this with your appKey

  bool rewardeVideoAvailable = false,
      offerwallAvailable = false,
      showBanner = false,
      interstitialReady = false;
  @override
  void initState() {
    //esto es para que escuche didChangeAppLifecycleState;
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration.zero, () async {
      await init();
    });

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        IronSource.activityResumed();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        IronSource.activityPaused();
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  Future init() async {
    var userId = await IronSource.getAdvertiserId();
    await IronSource.validateIntegration();
    await IronSource.setUserId(userId);
    await IronSource.initialize(
      // final res =
      appKey: appKey,
      listener: this,
      gdprConsent: true,
      ccpaConsent: true,
      isChildDirected: false,
    );
    // print('IronSource.initialize--->$res');

    interstitialReady = await IronSource.isInterstitialReady();
    rewardeVideoAvailable = await IronSource.isRewardedVideoAvailable();
    offerwallAvailable = await IronSource.isOfferwallAvailable();

    setState(() {
      widget.bannerProvider.isBannerShow = true;
    });
  }

  void loadInterstitial() async {
    IronSource.loadInterstitial();
  }

  void showInterstitial() async {
    //&& !(await IronSource.isInterstitialPlacementCapped('placementName')
    if (await IronSource.isInterstitialReady()) {
      // showHideBanner();
      IronSource.showInterstitial(placementName: "DefaultInterstitial");
    } else {
      // print(
      //   "Interstial is not ready. use 'Ironsource.loadInterstial' before showing it",
      // );
    }
  }

  void showOfferwall() async {
    if (await IronSource.isOfferwallAvailable()) {
      // showHideBanner();
      IronSource.showOfferwall();
    } else {
      // print("Offerwall not available");
    }
  }

  void showRewardedVideo() async {
    if (await IronSource.isRewardedVideoAvailable()) {
      // showHideBanner();
      IronSource.showRewardedVideo();
    } else {
      // print("RewardedVideo not available");
    }
  }

  void showHideBanner() {
    setState(() {
      showBanner = !showBanner;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CustomButton(
          label: "Load interstitial",
          onPressed: loadInterstitial,
        ),
        CustomButton(
          label: "Show interstitial",
          onPressed: interstitialReady ? showInterstitial : null,
        ),
        CustomButton(
          label: "Show offerwall",
          onPressed: offerwallAvailable ? showOfferwall : null,
        ),
        CustomButton(
          label: "Show Rewarded Video",
          onPressed: rewardeVideoAvailable ? showRewardedVideo : null,
        ),
      ],
    );
  }

  bool get wantKeepAlive => true;

  @override
  void onInterstitialAdClicked() {
    // print("onInterstitialAdClicked");
  }

  @override
  void onInterstitialAdClosed() {
    // print("onInterstitialAdClosed");
  }

  @override
  void onInterstitialAdLoadFailed(IronSourceError error) {
    // print("onInterstitialAdLoadFailed : ${error.toString()}");
  }

  @override
  void onInterstitialAdOpened() {
    // print("onInterstitialAdOpened");
    setState(() {
      interstitialReady = false;
    });
  }

  @override
  void onInterstitialAdReady() {
    // print("onInterstitialAdReady");
    setState(() {
      interstitialReady = true;
    });
  }

  @override
  void onInterstitialAdShowFailed(IronSourceError error) {
    // print("onInterstitialAdShowFailed : ${error.toString()}");
    setState(() {
      interstitialReady = false;
    });
  }

  @override
  void onInterstitialAdShowSucceeded() {
    // print("nInterstitialAdShowSucceeded");
  }

  @override
  void onGetOfferwallCreditsFailed(IronSourceError error) {
    // print("onGetOfferwallCreditsFailed : ${error.toString()}");
  }

  @override
  void onOfferwallAdCredited(OfferwallCredit reward) {
    // print("onOfferwallAdCredited : $reward");
  }

  @override
  void onOfferwallAvailable(bool available) {
    // print("onOfferwallAvailable : $available");

    setState(() {
      offerwallAvailable = available;
    });
  }

  @override
  void onOfferwallClosed() {
    // print("onOfferwallClosed");
  }

  @override
  void onOfferwallOpened() {
    // print("onOfferwallOpened");
  }

  @override
  void onOfferwallShowFailed(IronSourceError error) {
    // print("onOfferwallShowFailed ${error.toString()}");
  }

  @override
  void onRewardedVideoAdClicked(Placement placement) {
    // print("onRewardedVideoAdClicked");
  }

  @override
  void onRewardedVideoAdClosed() {
    // print("onRewardedVideoAdClosed");
  }

  @override
  void onRewardedVideoAdEnded() {
    // print("onRewardedVideoAdEnded");
  }

  @override
  void onRewardedVideoAdOpened() {
    // print("onRewardedVideoAdOpened");
  }

  @override
  void onRewardedVideoAdRewarded(Placement placement) {
    // print("onRewardedVideoAdRewarded: ${placement.placementName}");
  }

  @override
  void onRewardedVideoAdShowFailed(IronSourceError error) {
    // print("onRewardedVideoAdShowFailed : ${error.toString()}");
  }

  @override
  void onRewardedVideoAdStarted() {
    // print("onRewardedVideoAdStarted");
  }

  @override
  void onRewardedVideoAvailabilityChanged(bool available) {
    // print("onRewardedVideoAvailabilityChanged : $available");
    setState(() {
      rewardeVideoAvailable = available;
    });
  }
}
