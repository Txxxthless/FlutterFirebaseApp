import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_firebase/models/image_model.dart';
import 'package:flutter_firebase/models/telescope.dart';
import 'package:flutter_firebase/pages/description_page.dart';
import 'package:flutter_firebase/providers/telescope_provider.dart';
import 'package:flutter_firebase/utils/constants.dart';
import 'package:flutter_firebase/utils/helper_functions.dart';
import 'package:flutter_firebase/utils/widget_functions.dart';
import 'package:flutter_firebase/widgets/image_holder_view.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class TelescopeDetailsPage extends StatefulWidget {
  static const String routeName = 'telescopedetails';
  final String id;

  const TelescopeDetailsPage({super.key, required this.id});

  @override
  State<TelescopeDetailsPage> createState() => _TelescopeDetailsPageState();
}

class _TelescopeDetailsPageState extends State<TelescopeDetailsPage> {
  late Telescope telescope;
  late TelescopeProvider provider;

  @override
  void didChangeDependencies() {
    provider = Provider.of<TelescopeProvider>(context);
    telescope = provider.findTelescopeById(widget.id);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          telescope.model,
          style: const TextStyle(
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      body: ListView(
        children: [
          CachedNetworkImage(
            width: double.infinity,
            height: 200,
            imageUrl: telescope.thumbnail.downloadUrl,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: Card(
              child: ListView(
                padding: const EdgeInsets.all(8),
                scrollDirection: Axis.horizontal,
                children: [
                  FloatingActionButton.small(
                    onPressed: () {
                      getImage(ImageSource.gallery);
                    },
                    tooltip: 'Add aditional image',
                    child: const Icon(
                      Icons.add,
                    ),
                  ),
                  if (telescope.additionalImages.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                      ),
                      child: Center(
                        child: Text(
                          'Add other images',
                        ),
                      ),
                    ),
                  ...telescope.additionalImages.map(
                    (e) => ImageHolderView(
                      imageModel: e,
                      onImagePressed: () {
                        _showImageOnDialog(e);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              telescope.description == null
                  ? context.goNamed(DescriptionPage.routeName,
                      extra: telescope.id)
                  : _showDescriptionDialog();
            },
            child: Text(
              telescope.description == null
                  ? 'Add Description'
                  : 'Show Description',
            ),
          ),
          ListTile(
            title: Text(
              telescope.brand.name,
            ),
            subtitle: Text(
              telescope.model,
            ),
          ),
          ListTile(
            title: Text(
              'Sale Price (width discount): $currencySymbol${priceAfterDiscount(telescope.price, telescope.discount).toStringAsFixed(0)}',
            ),
            subtitle: Text(
              'Original Price: $currencySymbol${telescope.price}',
            ),
            trailing: IconButton(
              onPressed: () {
                showSingleTextInputDialog(
                  context: context,
                  title: 'Edit Price',
                  onSubmit: (value) {
                    EasyLoading.show(status: 'Saving');
                    provider.updateTelescopeField(
                      telescope.id!,
                      'price',
                      num.parse(value),
                    );
                    EasyLoading.dismiss();
                  },
                );
              },
              icon: const Icon(
                Icons.edit,
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Discount: $currencySymbol${telescope.discount}',
            ),
            trailing: IconButton(
              onPressed: () {
                showSingleTextInputDialog(
                  context: context,
                  title: 'Edit Discount',
                  onSubmit: (value) {
                    EasyLoading.show(status: 'Saving');
                    provider.updateTelescopeField(
                      telescope.id!,
                      'discount',
                      num.parse(value),
                    );
                    EasyLoading.dismiss();
                  },
                );
              },
              icon: const Icon(
                Icons.edit,
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Stock: ${telescope.stock}',
            ),
            trailing: IconButton(
              onPressed: () {
                showSingleTextInputDialog(
                  context: context,
                  title: 'Edit Stock',
                  onSubmit: (value) {
                    EasyLoading.show(status: 'Saving');
                    provider.updateTelescopeField(
                      telescope.id!,
                      'stock',
                      num.parse(value),
                    );
                    EasyLoading.dismiss();
                  },
                );
              },
              icon: const Icon(
                Icons.edit,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getImage(ImageSource source) async {
    final file =
        await ImagePicker().pickImage(source: source, imageQuality: 50);
    if (file != null) {
      EasyLoading.show(status: 'Please wait');
      final newImageModel = await provider.uploadImage(file.path);
      telescope.additionalImages.add(newImageModel);
      provider
          .updateTelescopeField(
        telescope.id!,
        'additionalImages',
        toImageMapList(telescope.additionalImages),
      )
          .then((value) {
        showMsg(context, 'Added');
        EasyLoading.dismiss();
        setState(() {});
      });
    }
  }

  void _showImageOnDialog(ImageModel e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: CachedNetworkImage(
          fit: BoxFit.contain,
          height: MediaQuery.of(context).size.height / 2,
          imageUrl: e.downloadUrl,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
          IconButton(
            onPressed: () async {
              Navigator.pop(context);
              EasyLoading.show(status: 'Please wait');

              try {
                await provider.deleteImage(telescope.id!, e);
                telescope.additionalImages.remove(e);
                await provider.updateTelescopeField(
                  telescope.id!,
                  'additinalImages',
                  toImageMapList(telescope.additionalImages),
                );
                setState(() {});
              } catch (e) {
                print(e);
              }

              EasyLoading.dismiss();
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  void _showDescriptionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Text(telescope.description!),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
              context.goNamed(DescriptionPage.routeName);
            },
            child: const Text('Edit'),
          ),
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
