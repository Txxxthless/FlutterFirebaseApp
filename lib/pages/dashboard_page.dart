import 'package:flutter/material.dart';
import 'package:flutter_firebase/auth/auth_service.dart';
import 'package:flutter_firebase/models/dashboard_model.dart';
import 'package:flutter_firebase/pages/login_page.dart';
import 'package:flutter_firebase/providers/telescope_provider.dart';
import 'package:flutter_firebase/widgets/dashboard_item_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName = '/';
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void didChangeDependencies() {
    Provider.of<TelescopeProvider>(context, listen: false).getAllBrands();
    Provider.of<TelescopeProvider>(context, listen: false).getAllTelescopes();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
        ),
        actions: [
          IconButton(
            onPressed: () {
              AuthService.logout()
                  .then((value) => context.goNamed(LoginPage.routeName));
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: dashboardModels.length,
        itemBuilder: (context, index) {
          final model = dashboardModels[index];
          return DashBoardItemView(
            model: model,
            onPress: (value) {
              context.goNamed(value);
            },
          );
        },
      ),
    );
  }
}
