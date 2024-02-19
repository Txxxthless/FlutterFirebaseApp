import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_firebase/providers/telescope_provider.dart';
import 'package:flutter_firebase/utils/widget_functions.dart';
import 'package:provider/provider.dart';

class BrandPage extends StatelessWidget {
  static const String routeName = 'brand';
  const BrandPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Brands'),
      ),
      body: Consumer<TelescopeProvider>(
        builder: (context, provider, child) => provider.brandList.isEmpty
            ? const Center(
                child: Text('No brand found'),
              )
            : ListView.builder(
                itemCount: provider.brandList.length,
                itemBuilder: (context, index) {
                  final brand = provider.brandList[index];
                  return ListTile(
                    title: Text(
                      brand.name,
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSingleTextInputDialog(
            context: context,
            title: 'Brand',
            onSubmit: (value) {
              EasyLoading.show(status: 'Please wait');
              Provider.of<TelescopeProvider>(context, listen: false)
              .addBrand(value)
              .then((value) {
                EasyLoading.dismiss();
                showMsg(context, 'Brand added');
              });
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
