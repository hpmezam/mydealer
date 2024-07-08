import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mydealer/controllers/auth_controller.dart';
import 'package:mydealer/localization/app_localization.dart';
import 'package:mydealer/localization/controllers/localization_controller.dart';
import 'package:mydealer/providers/download_provider.dart';
import 'package:mydealer/theme/controllers/theme_controller.dart';
import 'package:mydealer/theme/dark_theme.dart';
import 'package:mydealer/theme/light_theme.dart';
import 'package:mydealer/utils/app_constants.dart';
// import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/check_gps_permissions.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (_) =>
              LocalizationController(sharedPreferences: sharedPreferences)),
      ChangeNotifierProvider(
          create: (_) => ThemeController(sharedPreferences: sharedPreferences)),
      ChangeNotifierProvider(create: (_) => AuthController()),
      ChangeNotifierProvider(create: (context) => DownloadProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    List<Locale> locals = [];
    for (var language in AppConstants.languages) {
      locals.add(Locale(language.languageCode!, language.countryCode));
    }
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: Provider.of<ThemeController>(context).darkTheme ? dark : light,
      locale: Provider.of<LocalizationController>(context).locale,
      localizationsDelegates: const [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: locals,
      home: const CheckGpsPermissions(), // Pantalla de verificación
    );
  }
}
