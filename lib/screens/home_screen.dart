import 'dart:async';
import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/fragments/home_fragment.dart';
import 'package:briefify/fragments/search_fragment.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/models/user_model.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:briefify/services/firebase_message_service.dart';
import 'package:briefify/widgets/home_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  bool homeSelected = true;

  BranchContentMetaData metadata = BranchContentMetaData();
  BranchUniversalObject? buo;
  BranchLinkProperties lp = BranchLinkProperties();
  BranchEvent? eventStandart;
  BranchEvent? eventCustom;

  StreamSubscription<Map>? streamSubscription;
  StreamController<String> controllerData = StreamController<String>();
  StreamController<String> controllerInitSession = StreamController<String>();
  StreamController<String> controllerUrl = StreamController<String>();

  void listenDynamicLinks() async {
    streamSubscription = FlutterBranchSdk.initSession().listen((data) {
      print('listenDynamicLinks - DeepLink Data: $data');
      controllerData.sink.add((data.toString()));
      if (data.containsKey('+clicked_branch_link') &&
          data['+clicked_branch_link'] == true) {
        print(
            '------------------------------------Link clicked----------------------------------------------');
        print('Custom title: ${data['title']}');
        print('Custom price: ${data['price']}');
        var a = data['price'];
        print(a);
        print('Custom imageUrl: ${data['imageUrl']}');
        print('Custom bool: ${data['custom_bool']}');
        print('Custom list number: ${data['custom_list_number']}');
        if (a != null || a != '') {
          // Means we need to navigate to next page
          print('Link Found');
          Navigator.pushReplacementNamed(context, urlRoute);
        } else {
          print('Link Not Found');
        }

        print(
            '------------------------------------------------------------------------------------------------');
        // SnackBarHelper(
        //     context: context,
        //     message: 'Link clicked: Custom string - ${data['custom_string']}',
        //     duration: 10);

        SnackBarHelper.showSnackBarWithoutAction(
          context,
          message: 'Link clicked: Custom string - ${data['price']}',
        );
      }
    }, onError: (error) {
      PlatformException platformException = error as PlatformException;
      print(
          'InitSession error: ${platformException.code} - ${platformException.message}');
      controllerInitSession.add(
          'InitSession error: ${platformException.code} - ${platformException.message}');
    });
  }

  void initDeepLinkData() {
    metadata = BranchContentMetaData()
      ..addCustomMetadata('custom_string', 'abc')
      ..addCustomMetadata('custom_number', 12345)
      ..addCustomMetadata('custom_bool', true)
      ..addCustomMetadata('custom_list_number', [1, 2, 3, 4, 5])
      ..addCustomMetadata('custom_list_string', ['a', 'b', 'c'])
      //--optional Custom Metadata
      ..contentSchema = BranchContentSchema.COMMERCE_PRODUCT
      ..price = 50.99
      ..currencyType = BranchCurrencyType.BRL
      ..quantity = 50
      ..sku = 'sku'
      ..productName = 'productName'
      ..productBrand = 'productBrand'
      ..productCategory = BranchProductCategory.ELECTRONICS
      ..productVariant = 'productVariant'
      ..condition = BranchCondition.NEW
      ..rating = 100
      ..ratingAverage = 50
      ..ratingMax = 100
      ..ratingCount = 2
      ..setAddress(
          street: 'street',
          city: 'city',
          region: 'ES',
          country: 'Brazil',
          postalCode: '99999-987')
      ..setLocation(31.4521685, -114.7352207);

    buo = BranchUniversalObject(
        canonicalIdentifier: 'flutter/branch',
        //parameter canonicalUrl
        //If your content lives both on the web and in the app, make sure you set its canonical URL
        // (i.e. the URL of this piece of content on the web) when building any BUO.
        // By doing so, we’ll attribute clicks on the links that you generate back to their original web page,
        // even if the user goes to the app instead of your website! This will help your SEO efforts.
        // canonicalUrl: 'https://flutter.dev',
        title: 'Flutter Branch Plugin',
        imageUrl:
            'https://flutter.dev/assets/flutter-lockup-4cb0ee072ab312e59784d9fbf4fb7ad42688a7fdaea1270ccf6bbf4f34b7e03f.svg',
        contentDescription: 'Flutter Branch Description',
        contentMetadata: BranchContentMetaData()
          ..addCustomMetadata('custom_string', 'abc')
          ..addCustomMetadata('custom_number', 12345)
          ..addCustomMetadata('custom_bool', true)
          ..addCustomMetadata('custom_list_number', [1, 2, 3, 4, 5])
          ..addCustomMetadata('custom_list_string', ['a', 'b', 'c']),

        // contentMetadata: metadata,
        keywords: ['Plugin', 'Branch', 'Flutter'],
        publiclyIndex: true,
        locallyIndex: true,
        expirationDateInMilliSec:
            DateTime.now().add(Duration(days: 365)).millisecondsSinceEpoch);

    lp = BranchLinkProperties(
        channel: 'facebook',
        feature: 'sharing',
        //parameter alias
        //Instead of our standard encoded short url, you can specify the vanity alias.
        // For example, instead of a random string of characters/integers, you can set the vanity alias as *.app.link/devonaustin.
        // Aliases are enforced to be unique** and immutable per domain, and per link - they cannot be reused unless deleted.
        //alias: 'https://branch.io' //define link url,
        stage: 'new share',
        campaign: 'xxxxx',
        tags: ['one', 'two', 'three'])
      ..addControlParam('\$uri_redirect_mode', '1')
      ..addControlParam('referring_user_id', 'asdf');

    eventStandart = BranchEvent.standardEvent(BranchStandardEvent.ADD_TO_CART)
      //--optional Event data
      ..transactionID = '12344555'
      ..currency = BranchCurrencyType.BRL
      ..revenue = 1.5
      ..shipping = 10.2
      ..tax = 12.3
      ..coupon = 'test_coupon'
      ..affiliation = 'test_affiliation'
      ..eventDescription = 'Event_description'
      ..searchQuery = 'item 123'
      ..adType = BranchEventAdType.BANNER
      ..addCustomData(
          'Custom_Event_Property_Key1', 'Custom_Event_Property_val1')
      ..addCustomData(
          'Custom_Event_Property_Key2', 'Custom_Event_Property_val2');

    eventCustom = BranchEvent.customEvent('Custom_event')
      ..addCustomData(
          'Custom_Event_Property_Key1', 'Custom_Event_Property_val1')
      ..addCustomData(
          'Custom_Event_Property_Key2', 'Custom_Event_Property_val2');
  }

  void generateLink() async {
    BranchResponse response =
        await FlutterBranchSdk.getShortUrl(buo: buo!, linkProperties: lp);
    if (response.success) {
      controllerUrl.sink.add('${response.result}');
    } else {
      controllerUrl.sink
          .add('Error : ${response.errorCode} - ${response.errorMessage}');
    }
  }

  @override
  void initState() {
    listenDynamicLinks();
    initDeepLinkData();
    FirebaseMessageService.startMessageListener(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _userData = Provider.of<UserProvider>(context);
    final UserModel _user = _userData.user;

    return SafeArea(
      child: Scaffold(
        key: _key,
        backgroundColor: kSecondaryColorLight,
        drawer: const HomeDrawer(),
        body: Column(
          children: [
            SizedBox(
                height: 185,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _key.currentState!.openDrawer();
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 39,
                            ),
                            // child: ClipRRect(
                            //   borderRadius: BorderRadius.circular(200),
                            //   child: FadeInImage(
                            //     placeholder: const AssetImage(userAvatar),
                            //     image: NetworkImage(_user.image),
                            //     fit: BoxFit.cover,
                            //     imageErrorBuilder: (context, object, trace) {
                            //       return Image.asset(
                            //         appLogo,
                            //         height: 50,
                            //         width: 50,
                            //       );
                            //     },
                            //     height: 50,
                            //     width: 50,
                            //   ),
                            // ),
                            child: Icon(
                              Icons.menu,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 37),
                            if (_user.city.isEmpty) const SizedBox(height: 9),
                            Text(
                              _user.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (_user.city.isNotEmpty)
                              Text(
                                _user.city,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(height: 39),
                              Image.asset(
                                appLogo,
                                height: 32,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 75,
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Expanded(flex: 1, child: Container()),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30)),
                                    ),
                                  )),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    homeSelected = !homeSelected;
                                  });
                                },
                                child: Container(
                                  child: Icon(
                                    homeSelected ? Icons.search : Icons.home,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: kPrimaryColorLight,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(200),
                                  color: Colors.white,
                                ),
                                child: Container(
                                  child: Icon(
                                    homeSelected ? Icons.home : Icons.search,
                                    color: Colors.white,
                                    size: 38,
                                  ),
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(200),
                                    color: kPrimaryColorLight,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (_user.badgeStatus ==
                                      badgeVerificationApproved) {
                                    Navigator.pushNamed(
                                        context, createPostRoute);
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            content: const Text(
                                                'You need to verify your profile before posting context'),
                                            title: const Text(
                                                'Verification Required'),
                                            actions: [
                                              CupertinoDialogAction(
                                                child: const Text('Start'),
                                                isDefaultAction: true,
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Navigator.pushNamed(context,
                                                      profileVerificationRoute);
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                },
                                child: Container(
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: kPrimaryColorLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )),
            homeSelected ? const HomeFragment() : const SearchFragment(),
          ],
        ),
      ),
    );
  }
}
