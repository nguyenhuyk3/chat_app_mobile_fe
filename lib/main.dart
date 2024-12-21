import 'package:chat_app_mobile_fe/bloc/chat/chat_home/chat_list/chat_list.bloc.dart';
import 'package:chat_app_mobile_fe/screens/authentication/login/login_screen.dart';
import 'package:chat_app_mobile_fe/screens/chat/chat_home_screen.dart';
import 'package:chat_app_mobile_fe/services/fcm.services.dart';
import 'package:chat_app_mobile_fe/services/notification.services.dart';
import 'package:chat_app_mobile_fe/utils/log.utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

final logger = Logger(printer: CustomPrinter());
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final notificationServices = NotificationServices();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  logger.w("==================================");
  logger.i("_firebaseMessagingBackgroundHandler (Background)");
  logger.i(message.data);
  logger.w("==================================");

  if (message.data["type"] == "offer") {
    notificationServices.showCallNotification(
      flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
      message: message,
    );
  }
}

// Future<void> initializeNotifications() async {
//   const AndroidInitializationSettings androidInitializationSettings =
//       AndroidInitializationSettings('@drawable/ic_launcher.png');
//   const InitializationSettings initializationSettings = InitializationSettings(
//     android: androidInitializationSettings,
//   );
//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse: chatListBloc.onNotificationResponse,
//   );
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late FCMService _fcmService;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _fcmService = FCMService(navigatorKey: _navigatorKey);
    _fcmService.setupFCM(_navigatorKey);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.paused) {
  //     // Ứng dụng chuyển sang chế độ background
  //     context.read<ChatListBloc>().handleAppInBackground();
  //   } else if (state == AppLifecycleState.resumed) {
  //     // Ứng dụng trở lại foreground
  //     context.read<ChatListBloc>().handleAppInForeground();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatListBloc(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        home: const LoginScreen(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => const ChatHomeScreen(),
          '/login': (BuildContext context) => const LoginScreen(),
        },
      ),
    );
  }
}
