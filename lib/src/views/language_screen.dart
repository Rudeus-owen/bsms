import 'package:bsms/src/localization/language_constant.dart';
import 'package:bsms/myapp.dart';
import 'package:bsms/src/utils/build_context.dart';
import 'package:bsms/src/utils/common_costant.dart';
import 'package:bsms/src/utils/secure_storage.dart';
import 'package:bsms/src/utils/size_config.dart';
import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  static const routeName = '/languagescreen';
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String? chooseLanguage;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getLang();
    });
    super.initState();
  }

  Future<void> getLang() async {
    final langCode = await SecureStorage().readString(LANGUAGE_CODE) ?? '';
    debugPrint("LanguageCode==>$langCode");
    setState(() {
      if (langCode.isEmpty) {
        chooseLanguage = "en";
      } else {
        chooseLanguage = langCode;
      }
    });
  }

  void _changeLanguage(String languageCode) async {
    Locale locale = await setLocale(languageCode);
    debugPrint("Locale===>$locale");

    if (locale.languageCode == "my") {
      isMyanLanguage = true;
    } else {
      isMyanLanguage = false;
    }
    MyApp.setLocale(context, locale);
  }

  @override
  Widget build(BuildContext context) {
    final width = SizeConfig.screenWidth;
    final height = SizeConfig.screenHeight;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          context.getTranslated("language"),
          style: TextStyle(
            fontSize: isMyanLanguage
                ? width > 600
                      ? 20
                      : 17
                : width > 600
                ? 21
                : 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 1,
                shadowColor: Colors.grey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          context.getTranslated("english"),
                          style: TextStyle(
                            fontSize: width > 600 ? 18 : 15,
                            color: chooseLanguage == "en"
                                ? Theme.of(context).primaryColor
                                : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        leading: Image.asset(
                          'assets/icons/en_lang_icon.png',
                          height: height > 1000 ? 40 : 30,
                          width: width > 600 ? 40 : 30,
                        ),
                        trailing: Radio<String>(
                          value: "en",
                          groupValue: chooseLanguage,
                          onChanged: (value) {
                            setState(() {
                              chooseLanguage = value;
                              _changeLanguage(chooseLanguage ?? 'en');
                              debugPrint("value=>$value");
                            });
                          },
                          activeColor: Theme.of(context).primaryColorDark,
                        ),
                      ),
                      SizedBox(height: height > 1000 ? 12 : 18),
                      ListTile(
                        title: Text(
                          context.getTranslated("myanmar"),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: width > 600 ? 18 : 15,
                            color: chooseLanguage == "my"
                                ? Theme.of(context).primaryColor
                                : Colors.black,
                          ),
                        ),
                        leading: Image.asset(
                          'assets/icons/my_lang_icon.png',
                          height: height > 1000 ? 40 : 30,
                          width: width > 600 ? 40 : 30,
                        ),
                        trailing: Radio<String>(
                          value: "my",
                          groupValue: chooseLanguage,
                          onChanged: (value) {
                            setState(() {
                              chooseLanguage = value;
                              _changeLanguage(chooseLanguage ?? 'en');
                              debugPrint("value=>$value");
                            });
                          },
                          activeColor: Theme.of(context).primaryColorDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
