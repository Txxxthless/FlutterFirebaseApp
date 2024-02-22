import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_firebase/auth/auth_service.dart';
import 'package:flutter_firebase/pages/add_telescope_page.dart';
import 'package:flutter_firebase/pages/brand_page.dart';
import 'package:flutter_firebase/pages/dashboard_page.dart';
import 'package:flutter_firebase/pages/description_page.dart';
import 'package:flutter_firebase/pages/login_page.dart';
import 'package:flutter_firebase/pages/telescope_details_page.dart';
import 'package:flutter_firebase/pages/view_telescope_page.dart';
import 'package:flutter_firebase/providers/telescope_provider.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TelescopeProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
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
        routes: [
          GoRoute(
            name: AddTelescopePage.routeName,
            path: AddTelescopePage.routeName,
            builder: (context, state) => AddTelescopePage(),
          ),
          GoRoute(
            name: ViewTelescopePage.routeName,
            path: ViewTelescopePage.routeName,
            builder: (context, state) => ViewTelescopePage(),
            routes: [
              GoRoute(
                name: TelescopeDetailsPage.routeName,
                path: TelescopeDetailsPage.routeName,
                builder: (context, state) =>
                    TelescopeDetailsPage(id: state.extra! as String),
                routes: [
                  GoRoute(
                    name: DescriptionPage.routeName,
                    path: DescriptionPage.routeName,
                    builder: (context, state) => DescriptionPage(id: state.extra! as String),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            name: BrandPage.routeName,
            path: BrandPage.routeName,
            builder: (context, state) => BrandPage(),
          ),
        ],
      ),
      GoRoute(
        name: LoginPage.routeName,
        path: LoginPage.routeName,
        builder: (context, state) => LoginPage(),
      ),
    ],
  );
}
