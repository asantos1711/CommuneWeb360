import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';
import 'package:google_fonts/google_fonts.dart';

import 'config/routes.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await GRecaptchaV3.ready("6LcVBwglAAAAAKAT2F1wARGSjVsfxAKByn--jlGH"); //--2

  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.space): ActivateIntent(),
      },
      title: 'Latitud',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: GoogleFonts.poppins().fontFamily,
          primarySwatch: Colors.blue,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      initialRoute: "/login",
      onGenerateRoute: RouterGenerator.generateRoute,
    );
  }
}
