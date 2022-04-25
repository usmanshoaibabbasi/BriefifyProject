import 'package:auto_orientation/auto_orientation.dart';
import 'package:briefify/models/category_model.dart';
import 'package:briefify/models/comment_model.dart';
import 'package:briefify/models/post_model.dart';
import 'package:briefify/models/user_model.dart';
import 'package:briefify/providers/home_posts_provider.dart';
import 'package:briefify/providers/post_observer_provider.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:briefify/screens/PostDetail.dart';
import 'package:briefify/screens/categories_screen.dart';
import 'package:briefify/screens/comments_screen.dart';
import 'package:briefify/screens/create_post_screen.dart';
import 'package:briefify/screens/edit_post_screen.dart';
import 'package:briefify/screens/followers_screen.dart';
import 'package:briefify/screens/following_screen.dart';
import 'package:briefify/screens/forgot_password_screen.dart';
import 'package:briefify/screens/getotp_screen.dart';
import 'package:briefify/screens/home_screen.dart';
import 'package:briefify/screens/login_screen.dart';
import 'package:briefify/screens/my_profile_screen.dart';
import 'package:briefify/screens/otp_screen.dart';
import 'package:briefify/screens/posts_by_category_screen.dart';
import 'package:briefify/screens/profile_verification_screen.dart';
import 'package:briefify/screens/register_screen.dart';
import 'package:briefify/screens/replies_screen.dart';
import 'package:briefify/screens/report_user.dart';
import 'package:briefify/screens/show_user_img.dart';
import 'package:briefify/screens/show_user_screen.dart';
import 'package:briefify/screens/splash_screen.dart';
import 'package:briefify/screens/term_and_condition.dart';
import 'package:briefify/screens/update_profile_screen.dart';
import 'package:briefify/screens/urlpage.dart';
import 'package:briefify/screens/wallet_screen.dart';
import 'package:briefify/screens/webview_screen.dart';
import 'package:briefify/screens/welcome_screen.dart';
import 'package:briefify/widgets/home_drawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/routes.dart';
import 'models/edit_post_argument.dart';
import 'models/route_argument.dart';
import 'screens/play_youtube_screen.dart';

// Errors in C:\src\flutter\.pub-cache\hosted\pub.dartlang.org\flutter_quill-3.9.9\lib\src\widgets\raw_editor.dart
// // ihavecommented TextEditingActionTarget,
// // ihavecommented super.copySelection(cause);
// // ihavecommented super.cutSelection(cause);
// ihavecommented super.pasteText(cause);
// ihavecommented super.selectAll(cause);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterBranchSdk.validateSDKIntegration();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AutoOrientation.portraitUpMode();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomePostsProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => PostProvider()),
        ChangeNotifierProvider(create: (context) => PostObserverProvider()),
      ],
      child: MaterialApp(
        title: 'Briefify',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'sofiapro-light',
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
        onGenerateRoute: (RouteSettings settings) {
          /// Welcome Route
          if (settings.name == welcomeRoute) {
            return MaterialPageRoute(
                builder: (context) => const WelcomeScreen());
          }

          /// Login Route
          if (settings.name == loginRoute) {
            return MaterialPageRoute(builder: (context) => const LoginScreen());
          }
          // Self Profile Photo Display Route
          if (settings.name == ImgeScreenProfile) {
            return MaterialPageRoute(
                builder: (context) => const ImgScreenProfile());
          }

          // Other User Cover Picture Display Route
          if (settings.name == OtherUserCoverImg) {
            final results = settings.arguments as Map;
            var modelSendToshowimg = results['user'];
            return MaterialPageRoute(
                builder: (context) => ShowOtherUserCoverPhoto(
                      user: modelSendToshowimg,
                    ));
          }
          // Other User Profile Picture Display Route
          if (settings.name == OtherUserProfileImg) {
            final results = settings.arguments as Map;
            var user = results['user'];
            return MaterialPageRoute(
                builder: (context) => OtherUserProfilePhoto(
                      user: user,
                    ));
          }

          /// Register Route
          if (settings.name == registerRoute) {
            return MaterialPageRoute(
                builder: (context) => const RegisterScreen());
          }

          /// Term & Condition Route
          if (settings.name == termandconditionRoute) {
            return MaterialPageRoute(
                builder: (context) => const TermAndConditionScreen());
          }

          /// Forgot Password Route
          if (settings.name == forgotPasswordRoute) {
            return MaterialPageRoute(
                builder: (context) => const ForgotPasswordScreen());
          }

          /// Update Profile Route
          if (settings.name == updateProfileRoute) {
            return MaterialPageRoute(
                builder: (context) => const UpdateProfileScreen());
          }

          /// Home Route
          if (settings.name == homeRoute) {
            return MaterialPageRoute(builder: (context) => const HomeScreen());
          }

          /// URl Route
          if (settings.name == urlRoute) {
            final results = settings.arguments as Map;
            var postID = results['postID'];
            return MaterialPageRoute(
                builder: (context) => UrlPage(
                      postID: postID,
                    ));
          }

          /// Create Post Route
          if (settings.name == createPostRoute) {
            return MaterialPageRoute(
                builder: (context) => const CreatePostScreen());
          }

          /// Edit Post Route
          if (settings.name == editPostRoute) {
            final results = settings.arguments as EditPostArgument;
            int userId = results.userId ?? 0;
            int postId = results.postId ?? 0;
            String heading = results.heading ?? " ";
            String summary = results.summary ?? " ";
            String videolink = results.videolink ?? " ";
            String ariclelink = results.ariclelink ?? " ";
            // String category = results.category ?? "";
            return MaterialPageRoute(
                builder: (context) => EditPostScreen(
                      userId: userId,
                      postId: postId,
                      heading: heading,
                      summary: summary,
                      videolink: videolink,
                      ariclelink: ariclelink,
                      // category: category,
                    ));
          }

          /// My Profile Route
          if (settings.name == myProfileRoute) {
            return MaterialPageRoute(
                builder: (context) => const MyProfileScreen());
          }

          /// Categories Route
          if (settings.name == categoriesRoute) {
            return MaterialPageRoute(
                builder: (context) => const CategoriesScreen());
          }

          /// wallet Route
          if (settings.name == walletRoute) {
            return MaterialPageRoute(
                builder: (context) => const WalletScreen());
          }

          /// Profile Verification Route
          if (settings.name == profileVerificationRoute) {
            return MaterialPageRoute(
                builder: (context) => const ProfileVerificationScreen());
          }

          /// Comments Route
          if (settings.name == commentsRoute) {
            final results = settings.arguments as Map;
            PostModel post = results['post'];
            return MaterialPageRoute(
                builder: (context) => CommentsScreen(post: post));
          }

          /// OTP Route
          if (settings.name == otpRoute) {
            final results = settings.arguments as Map;
            final String phoneNumber = results['phoneNumber'];
            return MaterialPageRoute(
                builder: (context) => OTPScreen(
                      phoneNumber: phoneNumber,
                    ));
          }
          // GET OTP Screen
          if (settings.name == getotpRoute) {
            return MaterialPageRoute(builder: (context) => GETOTPSCREEN());
          }

          /// Replies Route
          if (settings.name == repliesRoute) {
            final results = settings.arguments as Map;
            CommentModel comment = results['comment'];
            return MaterialPageRoute(
                builder: (context) => RepliesScreen(comment: comment));
          }

          /// Webview Route
          if (settings.name == webviewRoute) {
            final results = settings.arguments as Map;
            String url = results['url'];
            return MaterialPageRoute(
                builder: (context) => WebviewScreen(url: url));
          }

          /// Show User Route
          if (settings.name == showUserRoute) {
            final results = settings.arguments as Map;
            UserModel user = results['user'];
            return MaterialPageRoute(
                builder: (context) => ShowUserScreen(
                      user: user,
                    ));
          }

          /// Show User Route URLPage
          if (settings.name == showUserRouteurl) {
            final results = settings.arguments as Map;
            UserModel user = results['user'];
            return MaterialPageRoute(
                builder: (context) => ShowUserScreen(
                      user: user,
                    ));
          }

          /// Followers Route
          if (settings.name == followersRoute) {
            final results = settings.arguments as Map;
            UserModel user = results['user'];
            return MaterialPageRoute(
                builder: (context) => FollowersScreen(user: user));
          }

          /// Following Route
          if (settings.name == followingRoute) {
            final results = settings.arguments as Map;
            UserModel user = results['user'];
            return MaterialPageRoute(
                builder: (context) => FollowingScreen(user: user));
          }

          /// Posts By Categories Route
          if (settings.name == postsByCategoryRoute) {
            final results = settings.arguments as Map;
            CategoryModel category = results['category'];
            return MaterialPageRoute(
                builder: (context) => PostsByCategoryScreen(
                      category: category,
                    ));
          }

          /// Following Route
          if (settings.name == ytScreen) {
            final results = settings.arguments as RouteArgument;
            String url = results.url ?? " ";
            return MaterialPageRoute(
                builder: (context) => PlayYTVideo(url: url));
          }

          // Report User Route
          if (settings.name == reportUserRoute) {
            final results = settings.arguments as Map;
            final int postid = results['postid'];
            final int postuserid = results['userid'];
            return MaterialPageRoute(
                builder: (context) => ReportUser(
                      postid: postid,
                      userid: postuserid,
                    ));
          }

          /// Post Detail
          if (settings.name == postdetailRoute) {
            final results = settings.arguments as Map;
            PostModel postModel = results['postModel'];
            return MaterialPageRoute(
                builder: (context) => PostDetail(
                      postModel: postModel,
                    ));
          }

          /// No route found
          assert(false, 'Need to implement ${settings.name}');
          return null;
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
