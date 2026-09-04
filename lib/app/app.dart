import 'package:flutter/material.dart';

import 'app_router.dart';
import 'app_theme.dart';

class AgriCentreApp extends StatelessWidget {
  const AgriCentreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriCentre',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}