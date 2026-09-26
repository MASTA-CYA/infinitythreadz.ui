import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:infinity_threadz/authentication-component/login_page.dart';
import 'package:infinity_threadz/common/themes.dart';
import 'package:infinity_threadz/common/widgets/app_load.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String title = 'Infinity Threadz';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait(
        [
          Future.delayed(
            const Duration(seconds: 4),
          ),
        ],
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return ThemeProvider(
            initTheme: AppThemes.lightTheme,
            builder: (_, theme) => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme,
              title: title,
              restorationScopeId: 'app',
              home: const LoginPage(),
            ),
          );
        } else {
          return ThemeProvider(
            initTheme: AppThemes.lightTheme,
            builder: (_, theme) => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme,
              title: title,
              restorationScopeId: 'app-load',
              home: const AppLoadWidget(),
            ),
          );
        }
      },
    );
  }
}
