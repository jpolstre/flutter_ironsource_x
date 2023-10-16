import 'package:flutter/material.dart';

import 'package:flutter_ironsource_x/ironsource.dart';
import 'package:flutter_ironsource_x_example/providers/banner_providers.dart';
import 'package:flutter_ironsource_x_example/widgets/button_ads_widget_and_init_ironsource.dart';
import 'package:flutter_ironsource_x_example/widgets/custom_button.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});
  final bannerProvider =
      BannerProvider(); //este provider se reparte en todo el widget

  @override
  State<MyApp> createState() => _MyAppState();
}

//puede ser un StatlessWidget tambien(ya que no se utiliza los estados)
class _MyAppState extends State<MyApp> {
  @override
  // void initState() {
  //   Future.delayed(const Duration(milliseconds: 2500), () {
  //     //ok
  //     widget.bannerProvider.isBannerShow = true;
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // print('reload all widgets');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => widget.bannerProvider,
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Flutter IronSource X Demo'),
          ),
          body: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ButtonAdsWidgetAndInitIronSource(
                        bannerProvider: widget.bannerProvider),

                    /*Consumer<BannerProvider>( es igual que Obx, se recarga por las propiedades de BannerProvider (notifyListeners();)
                    todos los BannerProvider (bannerProv en este caso) de Consumer<BannerProvider>, son widget.bannerProvider(es uno solo en otras palabras)*/
                    Consumer<BannerProvider>(
                        builder: (context, bannerProv, child) {
                      // print('reload Consumer CustomButton');
                      return CustomButton(
                        label: bannerProv.isBannerShow //widget.bannerProvider
                            ? "hide banner"
                            : "Show Banner",
                        onPressed: () {
                          bannerProv.isBannerShow = !bannerProv.isBannerShow;
                        },
                      );
                    }),
                  ],
                ),
              ),
              /*Consumer<BannerProvider>( es igual que Obx, se recarga por las propiedades de BannerProvider (notifyListeners();)
                    todos los BannerProvider (bannerProv en este caso) de Consumer<BannerProvider>, son widget.bannerProvider(es uno solo en otras palabras)*/
              Consumer<BannerProvider>(builder: (context, bannerProv, child) {
                // print('reload Consumer Align osea Banner');

                return bannerProv.isBannerShow //widget.bannerProvider
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: IronSourceBannerAd(
                          keepAlive: true,
                          listener: BannerAdListener(),
                          size: BannerSize.BANNER,
                          placementName: "DefaultBanner",
                          // size: BannerSize.LARGE,
                          // size: BannerSize.LEADERBOARD,
                          // size: BannerSize.RECTANGLE,
                          // size: BannerSize.SMART,
                          /* size: BannerSize(
                          type: BannerSizeType.BANNER,
                          width: 400,
                          height: 50,
                        ), */
                          // backgroundColor: Colors.amber,
                        ),
                      )
                    : const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class BannerAdListener extends IronSourceBannerListener {
  @override
  void onBannerAdClicked() {
    // print("onBannerAdClicked");
  }

  @override
  void onBannerAdLeftApplication() {
    // print("onBannerAdLeftApplication");
  }

  @override
  void onBannerAdLoadFailed(Map<String, dynamic> error) {
    // print("onBannerAdLoadFailed");
  }

  @override
  void onBannerAdLoaded() {
    // print("onBannerAdLoaded");
  }

  @override
  void onBannerAdScreenDismissed() {
    // print("onBannerAdScreenDismisse");
  }

  @override
  void onBannerAdScreenPresented() {
    // print("onBannerAdScreenPresented");
  }
}

/*


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BannerProvider()),
      ],
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Flutter IronSource X Demo'),
          ),
          body: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                alignment: Alignment.center,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ButtonAdsWidget(),
                    BannerWidget(),
                  ],
                ),
              ),
              // Banner ad
              Consumer<BannerProvider>(builder: (context, bannerProv, child) {
                return bannerProv.isBannerShow
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: IronSourceBannerAd(
                          keepAlive: true,
                          listener: BannerAdListener(),
                          size: BannerSize.BANNER,
                          placementName: "DefaultBanner",
                          // size: BannerSize.LARGE,
                          // size: BannerSize.LEADERBOARD,
                          // size: BannerSize.RECTANGLE,
                          // size: BannerSize.SMART,
                          /* size: BannerSize(
                          type: BannerSizeType.BANNER,
                          width: 400,
                          height: 50,
                        ), */
                          // backgroundColor: Colors.amber,
                        ),
                      )
                    : const SizedBox();
              }),
            ],
          ),
        ),
      ),
    );
  }
}

*/
