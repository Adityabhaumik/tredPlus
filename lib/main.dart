import 'package:example/firebase_options.dart';
import 'package:example/view/share_location_screen/share_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utils/locators/setup_locators.dart';
import 'view/home_screen/home_screen.dart';
import 'view/view_shared_location/view_shared_location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
      routes: {
        HomePage.id: (context) => HomePage(),
        ShareLocationScreen.id: (context) => const ShareLocationScreen(),
        ViewSharedLocationScreen.id: (context) => ViewSharedLocationScreen(),
      },
    );
  }
}
