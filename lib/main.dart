import 'package:doctor/auth/login.dart';
import 'package:doctor/auth/onboarding.dart';
import 'package:doctor/constant/strings.dart';
import 'package:doctor/homepage/dashboard.dart';
import 'package:doctor/notification/helper_notification.dart';
import 'package:doctor/person/user.dart';
import 'package:doctor/providers/page_controller.dart';
import 'package:doctor/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('A bg message just showed up : ${message.messageId}');
}

// key ID W3GQWWTG35
// 4M5F6CFH72
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Set the background messaging handler early on, as a named top-level function
  final RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (remoteMessage != null) {}
  await HelperNotification.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(UserAdapter());

  await Hive.openBox<User>(BoxName);
  await Hive.openBox(ReferralBox);
  await Hive.openBox('Initialization');
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  ErrorWidget.builder = ((details) => Material(
        child: Container(
          color: Colors.green,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                details.exceptionAsString(),
                style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: Colors.white),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final box = Hive.box('Initialization');
    final Box<User> user = Hive.box<User>(BoxName);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<HomeController>(create: (_) => HomeController()),
      ],
      child: GetMaterialApp(
        title: 'Doctor',
        defaultTransition: Transition.zoom,
        debugShowCheckedModeBanner: true,
        theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity, primarySwatch: Colors.blue, primaryColor: Colors.black54),
        home: box.get('isFirst') == null
            ? Scaffold(body: OnBoardingScreen())
            : user.get(USERPATH) == null
                ? const AuthLogin()
                : Dashboard(),
      ),
    );
  }
}
