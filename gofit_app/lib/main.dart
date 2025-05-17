import 'package:fitness_app/screens/core/firebase_options.dart';
import 'package:fitness_app/screens/onboarding/splash_screen.dart';
import 'package:fitness_app/screens/provider/goal_provider.dart';
import 'package:fitness_app/screens/provider/workout_provider.dart';
import 'package:fitness_app/screens/provider/workout_state.dart'; // استيراد WorkoutState
import 'package:fitness_app/screens/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationService.init();
  print('🔔 Received background message: ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Hive.initFlutter();
  await Hive.openBox('goalsBox');
  await Hive.openBox('profileBox');
  await Hive.openBox('activityBox');
  await Hive.openBox('completedWorkouts');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GoalProvider()..loadGoals(),
        ), // GoalProvider
        ChangeNotifierProvider(create: (_) => WorkoutState()),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
      ],
      child: GoFitApp(),
    ),
  );
}

class GoFitApp extends StatefulWidget {
  @override
  _GoFitAppState createState() => _GoFitAppState();
}

class _GoFitAppState extends State<GoFitApp> {
  @override
  void initState() {
    super.initState();
    _initFCM();
  }

  void _initFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // iOS permissions
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📲 Foreground message received: ${message.notification?.title}');
    });

    // message opened from terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('🟢 Message clicked!');
    });

    String? token = await messaging.getToken();
    print('📬 FCM Token: $token');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoFit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
      home: SplashScreen(),
    );
  }
}
