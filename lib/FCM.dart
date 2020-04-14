import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;
  Function onMessage;
  Function onLaunch;
  Function onResume;
  Function getTokenCallback;

  FirebaseNotifications.handler(this.onMessage, this.onLaunch, this.onResume) {
    setUpFirebase();
  }
  FirebaseNotifications.getToken(this.getTokenCallback) {
    if (Platform.isIOS) iOSPermission();
    _firebaseMessaging = FirebaseMessaging();
    // _firebaseMessaging.deleteInstanceID().then((b) {
      // print('instance deleted $b');
      _firebaseMessaging.getToken().then((token) {
        print(token);
        getTokenCallback(token);
      // });
    });
  }

  void setUpFirebase() {
    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessagingListeners();
  }

  void firebaseCloudMessagingListeners() {
    // if (Platform.isIOS) iOS_Permission();
    // _firebaseMessaging.getToken().then((token) {
    //   print('This is FCM Token: $token');
    //   getTokenCallback(token);
    // });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        onMessage(message['notification']['body']);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        onResume(message['notification']['body']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        onLaunch(message['notification']['body']);
      },
    );
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}
