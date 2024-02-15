import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_firebase/auth/auth_service.dart';
import 'package:flutter_firebase/pages/dashboard_page.dart';
import 'package:flutter_firebase/pages/login_page.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      builder: EasyLoading.init(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }

  final _router = GoRouter(
    initialLocation: DashboardPage.routeName,
    redirect: (context, state) {
      if (AuthService.currentUser == null) {
        return LoginPage.routeName;
      }
      return null;
    },
    routes: [
      GoRoute(
        name: DashboardPage.routeName,
        path: DashboardPage.routeName,
        builder: (context, state) => DashboardPage(),
      ),
      GoRoute(
        name: LoginPage.routeName,
        path: LoginPage.routeName,
        builder: (context, state) => LoginPage(),
      ),
    ],
  );
}
