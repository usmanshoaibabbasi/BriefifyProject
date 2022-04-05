import 'package:briefify/providers/post_observer_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class FirebaseMessageService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void startMessageListener(context) async {
    final _postObserver =
        Provider.of<PostObserverProvider>(context, listen: false);

    /// Local Notification
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('flutter_devs');
    var initializationSettingsIOs = const IOSInitializationSettings();
    var initSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'Notifications',
      'Events Notifications',
      // 'Notifies you about the events',
      // Todo 'Notifies you about the events', commented due to error
      icon: 'flutter_devs',
      largeIcon: DrawableResourceAndroidBitmap('flutter_devs'),
    );
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await FirebaseMessaging.instance.getToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _postObserver.incrementCount();
      String notificationTitle = message.notification!.title.toString();
      String notificationBody = message.notification!.body.toString();
      flutterLocalNotificationsPlugin.show(
          0, notificationTitle, notificationBody, platformChannelSpecifics);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> sendNotification(String title, String body) async {
    /// Local Notification
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('flutter_devs');
    var initializationSettingsIOs = const IOSInitializationSettings();
    var initSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'Notifications',
      'Events Notifications',
      // 'Notifies you about the events',
      // Todo commented 'Notifies you about the events', due to error
      icon: 'flutter_devs',
      largeIcon: DrawableResourceAndroidBitmap('flutter_devs'),
    );
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics);
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('A background notification');
}
