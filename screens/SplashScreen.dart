import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Creativebuffer/localization/app_translations.dart';
import 'package:Creativebuffer/localization/app_translations_delegate.dart';
import 'package:Creativebuffer/localization/application.dart';
import 'package:Creativebuffer/utils/FunctinsData.dart';
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './Login.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  AppTranslationsDelegate _newLocaleDelegate;
  AppTranslations appTranslations;
  Animation animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;

    //getting language code from memory and using this code we fetch translated data from asset/locale
    Utils.getStringValue('lang').then((value) {
      if (value != null) {
        _newLocaleDelegate = AppTranslationsDelegate(newLocale: Locale(value));
        _newLocaleDelegate.load(Locale(value)).then((val) {
          if (!mounted) return;
          setState(() {
            appTranslations = val;
          });
        });
      }
    });

    Route route;
    controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    animation = Tween(begin: 30.0, end: 90.0).animate(controller);
    controller.forward();

    Future.delayed(Duration(seconds: 3), () {
      getBooleanValue('isLogged').then((value) {
        if (value) {
          Utils.getStringValue('rule').then((rule) {
            AppFunction.getFunctions(context, rule);
          });
        } else {
          route = MaterialPageRoute(builder: (context) => LoginScreen());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/splash_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topCenter,
                    height: 10.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/line.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Text(
                            appTranslations != null
                                ? appTranslations.text('Welcome to')
                                : 'Welcome to',
                            style: TextStyle(
                              color: Color(0xFF727FC8),
                              fontSize: 20.0,
                              fontFamily: 'popins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        AnimatedBuilder(
                          animation: animation,
                          builder: (context, child) {
                            return Container(
                              height: animation.value,
                              width: animation.value,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: ExactAssetImage(
                                      'assets/images/splash_logo.png'),
                                ),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 60.0),
                          child: Text(
                            appTranslations != null
                                ? appTranslations
                                    .text('UNLIMITED EDUCATION ERP')
                                : 'UNLIMITED EDUCATION ERP',
                            style: TextStyle(
                                color: Color(0xFF727FC8),
                                fontSize: 10.0,
                                fontFamily: 'popins',
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 80.0, left: 40, right: 40),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> getBooleanValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  void onLocaleChange(Locale locale) {
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
  }
}
