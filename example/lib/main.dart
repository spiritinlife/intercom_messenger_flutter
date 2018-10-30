import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intercom_messenger/intercom_messenger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() {

  IntercomMessenger.initialize('xxxxxxxx', androidApiKey: 'android_sdk-xxxxx..', iosApiKey: 'ios_sdk-xxxx...');

  IntercomMessenger.registerUnidentifiedUser();
  IntercomMessenger.setLauncherVisibility(false);
  IntercomMessenger.setInAppMessageVisibility(false);

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
      IntercomMessenger.handleIntercomPushNotification(message);
    },
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
      IntercomMessenger.handleIntercomPushNotification(message);
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
      IntercomMessenger.handleIntercomPushNotification(message);
    },
  );
  _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true));
  _firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings) {
    print("Settings registered: $settings");
  });
  _firebaseMessaging.getToken().then((String token) {
    assert(token != null);
    print("fcm token: " + token);
    IntercomMessenger.sendTokenToIntercom(token);
  });
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var messagesCount = 0;
  StreamSubscription<int> _unreadConversationCountSubscription;

  @override
  void initState() {
    super.initState();
    _unreadConversationCountSubscription = IntercomMessenger.addUnreadConversationCountListener().listen((_messagesCount) => setState(() {
      this.messagesCount = _messagesCount;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
            child: MaterialButton(
                child: Text("Open messenger $messagesCount"),
                onPressed: () => IntercomMessenger.displayMessenger())),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_unreadConversationCountSubscription != null) {
      _unreadConversationCountSubscription.cancel();
    }
  }
}
