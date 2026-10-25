import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:studentconnect/data/Authentications/google_signin.dart';
import 'package:studentconnect/firebase_options.dart';
import 'package:studentconnect/injection/database.dart';
import 'package:studentconnect/routes/pages.dart';
import 'package:studentconnect/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setup();
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessaging);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> firebaseBackgroundMessaging(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'StudentConnect',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      getPages: Pages.pages,
      initialRoute:
          Auth.currentUser == null ? AppRoutes.user : AppRoutes.main,
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ),
      ),
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
