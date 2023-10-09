import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void initFirebaseMessaging() async {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  /// Create a [AndroidNotificationChannel] for heads up notifications
  late AndroidNotificationChannel channel;

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  var androidInitialize =
      const AndroidInitializationSettings('mipmap/ic_launcher');
  var iOSInitialize = const DarwinInitializationSettings();
  var initializationsSettings =
      InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
  await flutterLocalNotificationsPlugin.initialize(initializationsSettings);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      // description
      importance: Importance.high,
    );
  }

  // _firebaseMessaging.subscribeToTopic("testing");

  /* To handle notification tap events, you must send the notification with custom data from the firebase console!
     * In Additional Options, in the "Custom data" section, add "click_action" in key, and "FLUTTER_NOTIFICATION_CLICK" in value.
     * If you don't do this, onResume or onLaunch will never get triggered!
     * For deep/dymanic links, put this in the custom data section too: "url" for key, and your link in value.
     */

  // see https://firebase.flutter.dev/docs/messaging/usage/#background-messages for why this was changed
  // and https://stackoverflow.com/a/67704651/6082224
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    onLaunchWorkaround(event.data);
  });
  //Foreground notifications handle here
  FirebaseMessaging.onMessage.listen((event) {
    log("onMessage: $event");
    RemoteNotification? notification = event.notification;

    if (notification != null) {
      flutterLocalNotificationsPlugin.show(
        event.notification.hashCode,
        event.notification?.title,
        event.notification?.body,
        NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
              subtitle: event.notification?.body,
            )),
      );
    }
  });

  firebaseMessaging.getToken().then((token) {
    assert(token != null);
    // log("FCM: $token");
  });
}

/// Workaround for current bug with FCM
/// Message gets saved and reloading the app
/// will trigger onLaunch again.
/// We store the Message ID and check the next time onLaunch is triggered
/// This prevents onLaunch from triggering the same notification more than once.
onLaunchWorkaround(Map<String, dynamic> message) async {
  // String? lastMessageId = await FlutterSecureStorage().read(key: 'lastMsgId');
  String currentMessageId;
  dynamic data = message['data'];
  if (data != null) {
    if (message['gcm.message_id'] != null) {
      currentMessageId = message['gcm.message_id'];
    } else {
      currentMessageId = data['google.message_id'];
    }

    // if (lastMessageId != null) {
    //   if (lastMessageId != currentMessageId) {
    //     handlePayload(message);
    //   }
    // } else {
    handlePayload(message);
    // }
  }
}

handlePayload(Map<String, dynamic> message) {
  if (message.containsKey('data') &&
          message['data'] != null &&
          message['data']['url'] != null ||
      message.containsKey('url') && message['url'] != null) {
    // final dynamic url = message['url'] ?? message['data']['url'];
    // final dynamic section = message['section'] ?? message['data']['section'];
    // if (url != null) locator<DynamicLinksService>().handleDeepLink(Uri.parse(url), section: section);
  }
}

//TODO: @Shahbaz why we are Using a Empty Function
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  // log("Handling a background message: ${message.messageId}");
}

Future<String> getFCMToken() async {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  String? fcmToken = await firebaseMessaging.getToken();
  return fcmToken ?? '';
}

Future initialize(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  var androidInitialize =
      const AndroidInitializationSettings('mipmap/ic_launcher');
  var iOSInitialize = const DarwinInitializationSettings();
  var initializationsSettings =
      InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
  await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
}
