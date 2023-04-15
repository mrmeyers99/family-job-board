import 'package:family_job_board/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logging/logging.dart';
import 'firebase_options.dart';
import 'screens/login_page.dart';

void main()  {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.time}: ${record.level.name}: ${record.loggerName}: ${record.message} ${record.error != null ? ': ' + record.error.toString() : ''} ${record.stackTrace != null ? ': ' + record.stackTrace.toString() : ''}');
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // primaryColor: AppConstants.primaryColor,
        colorScheme: const ColorScheme(primary: AppConstants.primaryColor, brightness: Brightness.light, onPrimary: AppConstants.text, secondary: AppConstants.accent, onSecondary: AppConstants.secondaryText, error: AppConstants.accent, onError: AppConstants.text, background: AppConstants.lightPrimaryColor, onBackground: AppConstants.text, surface: AppConstants.lightPrimaryColor, onSurface: AppConstants.text),
      ),
      home: LoginPage(),
    );
  }
}
