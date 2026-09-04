import 'package:flutter/material.dart';

import '../presentation/screens/farm/farm_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/login/login_screen.dart';
import '../presentation/screens/monitoring/monitoring_screen.dart';
import '../presentation/screens/payment/payment_screen.dart';
import '../presentation/screens/quality/quality_screen.dart';
import '../presentation/screens/register/register_screen.dart';
import '../presentation/screens/reports/reports_screen.dart';
import '../presentation/screens/settings/settings_screen.dart';
import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/transport/transport_screen.dart';

class AppRouter {
  AppRouter._();

  // Route names
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String farm = '/farm';
  static const String quality = '/quality';
  static const String transport = '/transport';
  static const String monitoring = '/monitoring';
  static const String reports = '/reports';
  static const String payment = '/payment';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        );

      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );

      case farm:
        return MaterialPageRoute(
          builder: (_) => const FarmScreen(),
        );

      case quality:
        return MaterialPageRoute(
          builder: (_) => const QualityScreen(),
        );

      case transport:
        return MaterialPageRoute(
          builder: (_) => const TransportScreen(),
        );

      case monitoring:
        return MaterialPageRoute(
          builder: (_) => const MonitoringScreen(),
        );

      case reports:
        return MaterialPageRoute(
          builder: (_) => const ReportsScreen(),
        );

      case payment:
        return MaterialPageRoute(
          builder: (_) => const PaymentScreen(),
        );

      case settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
    }
  }
}