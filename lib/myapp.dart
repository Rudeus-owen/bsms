import 'package:bsms/src/localization/demolocalization.dart';
import 'package:bsms/src/localization/language_constant.dart';
import 'package:bsms/src/utils/common_costant.dart';
import 'package:bsms/src/views/language_screen.dart';
import 'package:bsms/src/views/service_list_screen.dart';
import 'package:bsms/src/views/service_record_detail_screen.dart';
import 'package:bsms/src/views/service_record_screen.dart';
import 'package:flutter/material.dart';
import 'package:bsms/exports.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void initState() {
    
    WidgetsBinding.instance.addObserver(this);
    getLocale().then((locale) {
      if (locale.languageCode == 'my') {
        isMyanLanguage = true;
      }
      setState(() {
        this._locale = locale;
      });
    });
    super.initState();
  }

  Locale? _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beauty Salon Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: AppColors.scaffoldBg,
      ),
      locale: _locale,
      supportedLocales: [
        Locale('en', "US"),
        Locale('my', "BU"),
      ],
      localizationsDelegates: [
        DemoLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode ==
                  locale!.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      initialRoute: SignInPage.routeName,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            switch (settings.name) {
              case SignInPage.routeName:
                return const SignInPage();
              case OverviewScreen.routeName:
                return const OverviewScreen();
              case ServiceRecordScreen.routeName:
                return const ServiceRecordScreen();
              case ServiceRecordDetailScreen.routeName:
                return const ServiceRecordDetailScreen();
              case ServiceListScreen.routeName:
                return const ServiceListScreen();
              case EmployeeScreen.routeName:
                return const EmployeeScreen();
              case EmployeeEditScreen.routeName:
                return const EmployeeEditScreen();
              case CustomerScreen.routeName:
                return const CustomerScreen();
              case LanguageScreen.routeName:
                return const LanguageScreen();
              default:
                return const SignInPage();
            }
          },
        );
      },
    );
  }
}
