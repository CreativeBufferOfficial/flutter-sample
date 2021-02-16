import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:Creativebuffer/screens/SplashScreen.dart';
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isRTL;

  @override
  void initState() {
    super.initState();

    Utils.getIntValue('locale').then((value) {
      setState(() {
        isRTL = value == 0 ? true : false;
        //Utils.showToast('$isRTL');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return isRTL != null
            ? isRTL
                ? MaterialApp(
                    title: "Creativebuffer",
                    debugShowCheckedModeBanner: false,
                    theme: basicTheme(),
                    home: Scaffold(
                      body: Splash(),
                    ),
                    localizationsDelegates: [
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: [
                      Locale("fa",
                          "IR"), // OR Locale('ar', 'AE') OR Other RTL locales
                    ],
                  )
                : MaterialApp(
                    title: "Creativebuffer",
                    debugShowCheckedModeBanner: false,
                    theme: basicTheme(),
                    home: Scaffold(
                      body: Splash(),
                    ),
                  )
            : Material(
                child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Center(child: Text('Loading...'))));
  }
}
