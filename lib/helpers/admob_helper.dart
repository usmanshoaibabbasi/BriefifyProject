import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobHelper {
  // static String get bannerUnit => 'ca-app-pub-3940256099942544/6300978111';
  static initialization() {
    if (MobileAds.instance == null) {
      MobileAds.instance.initialize();
    }
  }

  // static NativeAd loadNativeAd() {
  //   NativeAd _ad = NativeAd(
  //     request: const AdRequest(),
  //     ///This is a test adUnitId make sure to change it
  //     // adUnitId: 'ca-app-pub-3940256099942544/2247696110',
  //     adUnitId: 'ca-app-pub-3940256099942544/2247696110',
  //     factoryId: 'listTile',
  //     listener: NativeAdListener(
  //         onAdLoaded: (ad){
  //           print('Ad loaded');
  //         },
  //         onAdFailedToLoad: (ad, error){
  //           ad.dispose();
  //           print('failed to load the ad ${error.message}, ${error.code}');
  //         }
  //     ),
  //   );
  //   return _ad;
  //
  // }


}
