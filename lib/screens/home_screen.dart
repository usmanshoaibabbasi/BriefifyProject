import 'dart:async';
import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/fragments/art_fragment.dart';
import 'package:briefify/fragments/home_fragment.dart';
import 'package:briefify/fragments/search_fragment.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/models/user_model.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:briefify/services/firebase_message_service.dart';
import 'package:briefify/widgets/home_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  int Selectedtab = 0;

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
        // print('Custom title: ${data['title']}');
        print('Custom postId: ${data['postId']}');
        var a = data['postId'];
        print(a);
        // print('Custom imageUrl: ${data['imageUrl']}');
        // print('Custom bool: ${data['custom_bool']}');
        // print('Custom list number: ${data['custom_list_number']}');
        if (a != null || a != '') {
          // Means we need to navigate to next page
          print('Link Found');
          Navigator.pushReplacementNamed(context, urlRoute,
              arguments: {'postID': a});
        } else {
          print('Link Not Found');
          SnackBarHelper.showSnackBarWithoutAction(
            context,
            message: 'Something Wrong:',
          );
        }

        print(
            '------------------------------------------------------------------------------------------------');
        // SnackBarHelper.showSnackBarWithoutAction(
        //   context,
        //   message: 'Link clicked: Custom string - ${data['postId']}',
        // );
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
        expirationDateInMilliSec: DateTime.now()
            .add(const Duration(days: 365))
            .millisecondsSinceEpoch);

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
          backgroundColor: const Color(0XffEDF0F4),
          drawer: const HomeDrawer(),
          body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Color(0xffFFFFFF),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          /// 1st container
                          Container(
                            height: MediaQuery.of(context).size.width*0.15,
                            // color: Colors.yellow,
                            padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _key.currentState!.openDrawer();
                                  },
                                  child: const Icon(
                                    Icons.menu,
                                    size: 30,
                                    color: Color(0xffBBBBBB),
                                  ),
                                ),
                                Image.asset(
                                  appLogo,
                                  height: 23,
                                  width: 75,
                                ),
                                GestureDetector(
                                  onTap: (() {
                                    setState(() {
                                      Selectedtab = 1;
                                    });
                                  }),
                                  child: const Icon(
                                    Icons.search_sharp,
                                    size: 30,
                                    color: kPrimaryColorLight,
                                  ),
                                )
                              ],
                            ),
                          ),
                          /// 2nd container
                          Container(
                            height: MediaQuery.of(context).size.width*0.10,
                            // color: Colors.green,
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            // color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Selectedtab = 0;
                                    });
                                  },
                                  child: Icon(
                                    FontAwesomeIcons.house,
                                    color: Selectedtab == 0
                                        ? kPrimaryColorLight
                                        : const Color(0xffBBBBBB),
                                    size: 25,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Selectedtab = 2;
                                    });
                                  },
                                  child: Icon(
                                    FontAwesomeIcons.leaf,
                                    color: Selectedtab == 2
                                        ? kPrimaryColorLight
                                        : const Color(0xffBBBBBB),
                                    size: 25,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, myProfileRoute);
                                  },
                                  child: RotationTransition(
                                    turns: const AlwaysStoppedAnimation(25 / 360),
                                    child: SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(200),
                                        child: Image.asset(
                                          launchericon,
                                          height: 30,
                                          width: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          /// 3rd container
                          Container(
                            height: MediaQuery.of(context).size.width*0.05,
                            // color: Colors.blue,
                          ),
                          /// 4th container
                          Container(
                            height: MediaQuery.of(context).size.width*0.15,
                            // color: Colors.brown,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, myProfileRoute);
                                  },
                                  child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(200),
                                      child: FadeInImage(
                                        placeholder: const AssetImage(userAvatar),
                                        image: NetworkImage(_user.image),
                                        fit: BoxFit.cover,
                                        imageErrorBuilder: (context, object, trace) {
                                          return Image.asset(
                                            appLogo,
                                            height: 30,
                                            width: 30,
                                          );
                                        },
                                        height: 30,
                                        width: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (_user.badgeStatus ==
                                          badgeVerificationApproved) {
                                        if(Selectedtab == 2) {
                                          Navigator.pushNamed(context, createArtRoute);
                                        }
                                        else {
                                          Navigator.pushNamed(context, createPostRoute);
                                        }
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
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                              color: const Color(0xffBBBBBB)),
                                          color: const Color(0xffFFFFFF)),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(20, 8, 0, 8),
                                        child: Text(
                                            Selectedtab == 2 ?
                                            'Share your Art...': 'Share your knowledge...'
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          /// 5th container
                          Container(
                            height: MediaQuery.of(context).size.width*0.05,
                            // color: Colors.indigo,
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: 1,
                ),
              ),
            ],
            body:
            Selectedtab == 1 ?
            Column(
              children: const [
                Expanded(
                  child: SingleChildScrollView(
                    child: SearchFragment(),
                  ),
                ),
              ],
            )  :
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Selectedtab == 0
                            ? const HomeFragment()
                            // : Selectedtab == 1
                            // ? const SearchFragment()
                            : const ArtFragment(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
