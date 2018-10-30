import 'dart:async';

import 'package:flutter/services.dart';

class METHODS {
  final _value;

  const METHODS._internal(this._value);

  toString() => '$_value';

  static const INTERCOM_INITIALISE =
  const METHODS._internal('INTERCOM_INITIALISE');
  static const INTERCOM_REGISTER_IDENTIFIED_USER =
  const METHODS._internal('INTERCOM_REGISTER_IDENTIFIED_USER');
  static const INTERCOM_REGISTER_UNIDENTIFIED_USER =
  const METHODS._internal('INTERCOM_REGISTER_UNIDENTIFIED_USER');
  static const INTERCOM_LOGOUT = const METHODS._internal('INTERCOM_LOGOUT');
  static const INTERCOM_UPDATE_USER_COMPANY =
  const METHODS._internal('INTERCOM_UPDATE_USER_COMPANY');
  static const INTERCOM_SET_COMPANY_CUSTOM_ATTRIBUTES =
  const METHODS._internal('INTERCOM_SET_COMPANY_CUSTOM_ATTRIBUTES');
  static const INTERCOM_UPDATE_USER =
  const METHODS._internal('INTERCOM_UPDATE_USER');
  static const INTERCOM_SET_USER_CUSTOM_ATTRIBUTES =
  const METHODS._internal('INTERCOM_SET_USER_CUSTOM_ATTRIBUTES');
  static const INTERCOM_SET_LAUNCHER_VISIBILITY =
  const METHODS._internal('INTERCOM_SET_LAUNCHER_VISIBILITY');
  static const INTERCOM_GET_UNREAD_CONVERSATION_COUNT =
  const METHODS._internal('INTERCOM_GET_UNREAD_CONVERSATION_COUNT');
  static const INTERCOM_ADD_UNREAD_CONVERSATION_COUNT_LISTENER =
  const METHODS._internal(
      'INTERCOM_ADD_UNREAD_CONVERSATION_COUNT_LISTENER');
  static const INTERCOM_SET_IN_APP_MESSAGE_VISIBILITY =
  const METHODS._internal('INTERCOM_SET_IN_APP_MESSAGE_VISIBILITY');
  static const INTERCOM_HIDE_MESSENGER =
  const METHODS._internal('INTERCOM_HIDE_MESSENGER');
  static const INTERCOM_DISPLAY_MESSENGER =
  const METHODS._internal('INTERCOM_DISPLAY_MESSENGER');
  static const INTERCOM_DISPLAY_HELP_CENTER =
  const METHODS._internal('INTERCOM_DISPLAY_HELP_CENTER');
  static const INTERCOM_SEND_TOKEN_TO_INTERCOM =
  const METHODS._internal('INTERCOM_SEND_TOKEN_TO_INTERCOM');
  static const INTERCOM_HANDLE_INTERCOM_PUSH_NOTIFICATION =
  const METHODS._internal('INTERCOM_HANDLE_INTERCOM_PUSH_NOTIFICATION');
}

class IntercomMessenger {
  static const MethodChannel _channel =
  const MethodChannel('intercom_messaging');

  static const EventChannel _eventChannel =
  const EventChannel('intercom_messaging_stream');


  static Stream<int> _unreadCountStream;


  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void initialize(String appId,
      {String androidApiKey, String iosApiKey}) {
    _channel.invokeMethod(METHODS.INTERCOM_INITIALISE.toString(), {
      'appId': appId,
      'androidApiKey': androidApiKey,
      'iosApiKey': iosApiKey
    });
  }

  static void registerUnidentifiedUser() {
    _channel.invokeMethod(METHODS.INTERCOM_REGISTER_UNIDENTIFIED_USER.toString());
  }

  static void setLauncherVisibility(bool isVisible) {
    _channel.invokeMethod(METHODS.INTERCOM_SET_LAUNCHER_VISIBILITY.toString(), {
      'visible' : isVisible
    });
  }

  static void setInAppMessageVisibility(bool isVisible) {
    _channel.invokeMethod(METHODS.INTERCOM_SET_IN_APP_MESSAGE_VISIBILITY.toString(), {
      'visible' : isVisible
    });
  }



  static void displayMessenger() {
    _channel.invokeMethod(METHODS.INTERCOM_DISPLAY_MESSENGER.toString());
  }


  static void sendTokenToIntercom(String token) {
    _channel.invokeMethod(METHODS.INTERCOM_SEND_TOKEN_TO_INTERCOM.toString(), {
      'refreshedToken' : token
    });
  }

  static void handleIntercomPushNotification(dynamic data) {
    _channel.invokeMethod(METHODS.INTERCOM_HANDLE_INTERCOM_PUSH_NOTIFICATION.toString(), data);
  }

  static Future<int> getUnreadConversationCountListener() async {
   return await _channel.invokeMethod(METHODS.INTERCOM_GET_UNREAD_CONVERSATION_COUNT.toString());
  }

  static Stream<int> addUnreadConversationCountListener() {
    _unreadCountStream ??= _eventChannel.receiveBroadcastStream().map((dynamic messagesCount) => messagesCount as int);
    return _unreadCountStream;
  }



}
