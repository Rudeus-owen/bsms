import 'dart:convert';
import 'dart:io';
import 'package:bsms/src/localization/demolocalization.dart';
import 'package:bsms/src/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

extension RouterContext on BuildContext {
  String getTranslated(String key) {
    return DemoLocalization.of(this)!.translate(key);
  }

  Future toPushAndRemoveUntilAnimation(
      {required Widget nextScreen, PageTransitionType? type}) {
    return Navigator.pushAndRemoveUntil(
        this,
        PageTransition(
          type: type ?? PageTransitionType.leftToRight,
          duration: Duration(milliseconds: 200),
          reverseDuration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: nextScreen,
        ),
        (r) => false);
  }

  Future toNextScreen(Widget nextScreen) {
    return Navigator.push(
      this,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        duration: Duration(milliseconds: 280),
        reverseDuration: Duration(milliseconds: 280),
        curve: Curves.easeInOut,
        child: nextScreen,
      ),
    );
  }

  Future toReplaceNextScreen(Widget nextScreen) {
    return Navigator.pushReplacement(
        this, MaterialPageRoute(builder: ((context) => nextScreen)));
  }

  Future toPushAndRemoveUntil(Widget nextScreen) {
    return Navigator.pushAndRemoveUntil(this,
        MaterialPageRoute(builder: (context) => nextScreen), (r) => false);
  }

  Future toNamedNextScreen(String routeName, {Object? args}) {
    return Navigator.pushNamed(this, routeName, arguments: args);
  }

  unFocus() {
    FocusScopeNode currentScope = FocusScope.of(this);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  double getKeyboardHeight() {
    FocusScopeNode currentScope = FocusScope.of(this);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      return SizeConfig.screenHeight * 0.3;
    } else {
      return 0;
    }
  }
}

extension EncodeFile on File {
  Future<String?> imageToBase64() async {
    try {
      List<int> imageBytes = await readAsBytes();
      String base64Image = base64Encode(imageBytes);
      return base64Image;
    } catch (e) {
      debugPrint("can't encode image : $e");
      return null;
    }
  }
}

extension ValidateEmail on String {
  bool isEmail() {
    final RegExp regex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    return regex.hasMatch(this);
  }
}

NumberFormat formatter = NumberFormat("#,##0", "en_US");

extension Pluralize on int {
  String pluralize(String singular, [String plural = 's']) =>
      this == 1 ? singular : singular + plural;
}

// extension PhoneFormat on String {
//   String thousandFormat() {
//     if (this.isEmpty) return '';
//     return formatter.format(double.parse(this));
//   }

//   String capitalize() {
//     return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
//   }

//   String getPhoneFormat() {
//     if (this.length >= 8 && this.length <= 13) {
//       if (this.indexOf("+") == 0 &&
//           (this.length == 12 || this.length == 13 || this.length == 11)) {
//         return this;
//       } else if (this.indexOf("09") == 0 &&
//           (this.length == 10 || this.length == 11 || this.length == 9)) {
//         return '+959' + this.substring(2);
//       } else if (this.indexOf("7") == 0 && this.length == 9) {
//         return '+959' + this;
//       } else if (this.indexOf("9") == 0 && this.length == 9) {
//         return '+959' + this.substring(1);
//       } else if (this.indexOf("9") == 0 &&
//           this.indexOf("959") != 0 &&
//           (this.length == 8 || this.length == 10)) {
//         return '+959' + this.substring(1);
//       } else if (this.indexOf("7") != 0 &&
//           this.indexOf("9") != 0 &&
//           (this.length == 6 || this.length == 9 || this.length == 7)) {
//         return '+959' + this;
//       } else if (this.indexOf("959") == 0 &&
//           (this.length == 11 || this.length == 12 || this.length == 10)) {
//         return '+959' + this.substring(3);
//       } else {
//         return "";
//       }
//     } else {
//       return "";
//     }
//   }
// }

// extension MonthToDigit on int {
//   String getMonthName() {
//     switch (this) {
//       case 1:
//         return "January";

//       case 2:
//         return "February";

//       case 3:
//         return "March";

//       case 4:
//         return "April";

//       case 5:
//         return "May";

//       case 6:
//         return "June";

//       case 7:
//         return "July";

//       case 8:
//         return "August";

//       case 9:
//         return "September";

//       case 10:
//         return "October";

//       case 11:
//         return "November";

//       case 12:
//         return "December";
//       default:
//         return "All";
//     }
//   }
// }

// extension OnNumber on num {
//   String get getDoubleOrInt {
//     if (toString().split('.').length > 1) {
//       if (int.parse(toString().split('.').elementAt(1)) > 0) {
//         return toDouble().toStringAsFixed(2);
//       } else {
//         return toInt().toString();
//       }
//     } else {
//       return toInt().toString();
//     }
//   }

//   bool get isInteger {
//     if (toString().split('.').length > 1) {
//       if (int.parse(toString().split('.').elementAt(1)) > 0) {
//         return false;
//       } else {
//         return true;
//       }
//     } else {
//       return true;
//     }
//   }
// }

// Future<String> getUUID() async {
//   String uuidCode = "";
//   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//   if (Platform.isAndroid) {
//     AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
//     uuidCode = androidDeviceInfo.id; // unique ID on Android
//   } else {
//     IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
//     uuidCode = iosDeviceInfo.identifierForVendor ?? ""; // unique ID on iOS
//   }
//   return uuidCode;
// }
