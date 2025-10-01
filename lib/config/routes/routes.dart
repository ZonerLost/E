import 'package:edwardb/Splash.dart';
import 'package:edwardb/config/routes/routes_names.dart';
import 'package:edwardb/screens/view/auth/login_screen/login_screen.dart';
import 'package:edwardb/screens/view/dashboard_screen/dashboard_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppRoutes {
  static appRoutes() => [
    ///
    /// Auth
    ///
    GetPage(name: RouteName.splashScreen, page: () => const Splash()),
    GetPage(name: RouteName.loginScreen, page: () => LoginScreen()),
    GetPage(
      name: RouteName.dashboardScreen,
      page: () => const DashboardScreen(),
    ),
  ];
}
