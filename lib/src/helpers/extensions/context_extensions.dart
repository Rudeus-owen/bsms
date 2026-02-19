import 'package:bsms/src/localization/demolocalization.dart';
import 'package:bsms/src/helpers/size_config.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

extension RouterContext on BuildContext {
  String getTranslated(String key) {
    return DemoLocalization.of(this)!.translate(key);
  }

  Future toPushAndRemoveUntilAnimation({
    required Widget nextScreen,
    PageTransitionType? type,
  }) {
    return Navigator.pushAndRemoveUntil(
      this,
      PageTransition(
        type: type ?? PageTransitionType.leftToRight,
        duration: Duration(milliseconds: 200),
        reverseDuration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: nextScreen,
      ),
      (r) => false,
    );
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
      this,
      MaterialPageRoute(builder: ((context) => nextScreen)),
    );
  }

  Future toPushAndRemoveUntil(Widget nextScreen) {
    return Navigator.pushAndRemoveUntil(
      this,
      MaterialPageRoute(builder: (context) => nextScreen),
      (r) => false,
    );
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
