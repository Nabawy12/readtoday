import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class DynamicAdWidget extends StatefulWidget {
  final String adUnitId;
  final String adType; // banner, interstitial, rewarded

  const DynamicAdWidget({
    required this.adUnitId,
    required this.adType,
    Key? key,
  }) : super(key: key);

  @override
  _DynamicAdWidgetState createState() => _DynamicAdWidgetState();
}

class _DynamicAdWidgetState extends State<DynamicAdWidget> {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;
  bool _isAdLoading = false;

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          //Navigator.pop(context); // Close the screen after the ad
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          //Navigator.pop(context); // Close the screen if ad fails to show
        },
      );

      _interstitialAd!.show();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    if (_isAdLoading) return; // Prevent loading an ad if one is already loading

    setState(() {
      _isAdLoading = true;
    });

    if (widget.adType == 'banner') {
      _bannerAd = BannerAd(
        adUnitId: widget.adUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) {
            setState(() {
              _isAdLoaded = true;
              _isAdLoading = false;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            setState(() {
              _isAdLoaded = false;
              _isAdLoading = false;
            });
            print('Banner ad failed to load: ${error.message}');
          },
        ),
      )..load();
    } else if (widget.adType == 'interstitial') {
      InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Test Ad Unit ID
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _isAdLoaded = true;
            print('Interstitial ad loaded successfully');
            // Show the ad immediately when loaded
            _showInterstitialAd();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('Interstitial ad failed to load: $error');
          },
        ),
      );
    } else if (widget.adType == 'rewarded') {
      RewardedAd.load(
        adUnitId: widget.adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedAd = ad;
            _rewardedAd!.show(
              onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
                print('User earned reward: ${reward.amount}');
              },
            );
            setState(() {
              _isAdLoading = false;
            });
          },
          onAdFailedToLoad: (error) {
            setState(() {
              _isAdLoading = false;
            });
            print('Rewarded ad failed to load: ${error.message}');
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.adType == 'banner') {
      if (_isAdLoading) {
        return const Center(
          child: SizedBox(),
        ); // Show a loading spinner while the ad is loading
      }
      return _isAdLoaded
          ? Container(
            height: _bannerAd!.size.height.toDouble(),
            width: _bannerAd!.size.width.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          )
          : const SizedBox(
            width: 350,
            height: 50,
          ); // Placeholder if ad fails to load
    }
    return const SizedBox(); // No UI for interstitial or rewarded ads
  }
}
