import 'dart:developer';

import 'package:bsms/src/views/service_list_screen.dart';
import 'package:bsms/src/views/service_record_detail_screen.dart';
import 'package:bsms/src/views/service_record_screen.dart';
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
              default:
                return const SignInPage();
            }
          },
        );
      },
    );
  }
}
