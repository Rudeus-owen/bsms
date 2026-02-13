import 'package:flutter/material.dart';
import 'package:bsms/exports.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beauty Salon Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: AppColors.scaffoldBg,
      ),
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
              case EmployeeScreen.routeName:
                return const EmployeeScreen();
              case EmployeeEditScreen.routeName:
                return const EmployeeEditScreen();
              default:
                return const SignInPage();
            }
          },
        );
      },
    );
  }
}
