import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/utils/helper.dart';
import '../api/home.dart';
import '../firebase_options.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationsService().handleNavigation(message.data);
}

class NotificationsService {
  static final NotificationsService _instance = NotificationsService._internal();

  factory NotificationsService() => _instance;

  NotificationsService._internal();

  String _tokenFB = '';
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'Rawmid',
    'Rawmid',
    description: 'This channel is used for important notifications.',
    playSound: true,
    importance: Importance.high,
  );

  Future<void> handleNavigation(Map<String, dynamic> data) async {
    if (data['click_action'] != null) {
      Helper.openLink('${data['click_action']}');
    }
  }

  Future<void> showNotifications(RemoteMessage message) async {
    final nav = Get.find<NavigationController>();

    if (nav.user.value != null && !nav.user.value!.push) {
      return;
    }

    int id = Random().nextInt(900) + 10;

    await flutterLocalNotificationsPlugin.show(
      id,
      message.notification?.title ?? 'Новое уведомление',
      message.notification?.body ?? '',
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'ic_notification',
          channelShowBadge: true,
          playSound: true,
          priority: Priority.high,
          importance: Importance.high,
          styleInformation: BigTextStyleInformation(message.notification?.body ?? ''),
        ),
        iOS: const DarwinNotificationDetails(
          presentBadge: true,
          presentSound: true,
          presentAlert: true,
          badgeNumber: 1,
        )
      ),
      payload: jsonEncode(message.data)
    );
  }

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          final data = jsonDecode(response.payload!);
          handleNavigation(data);
        }
      }
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true
    );

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
    );

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotifications(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      handleNavigation(message.data);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        handleNavigation(message.data);
      }
    });

    if (Platform.isIOS) {
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();

      if (apnsToken != null) {
        _tokenFB = await FirebaseMessaging.instance.getToken() ?? '';
      }
    } else {
      _tokenFB = await FirebaseMessaging.instance.getToken() ?? '';
    }
  }

  static bool _isRequestingPermission = false;

  static Future<void> start() async {
    if (_isRequestingPermission) {
      return;
    }

    _isRequestingPermission = true;

    try {
      await NotificationsService().initialize();

      final token = await NotificationsService.getToken();

      if (token.isNotEmpty) {
        await HomeApi.saveToken(token);
      }
    } catch (e) {
      //
    } finally {
      _isRequestingPermission = false;
    }
  }

  static Future<String> getToken() async {
    return NotificationsService()._tokenFB;
  }
}