import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase/db/db_helper.dart';
import 'package:flutter_firebase/models/brand.dart';
import 'package:flutter_firebase/models/image_model.dart';
import 'package:flutter_firebase/models/telescope.dart';
import 'package:flutter_firebase/utils/constants.dart';

class TelescopeProvider with ChangeNotifier {
  List<Brand> brandList = [];
  List<Telescope> telescopeList = [];

  Future<void> addBrand(String name) {
    final brand = Brand(name: name);
    return DbHelper.addBrand(brand);
  }

  getAllBrands() {
    DbHelper.getAllBrands().listen((snapshot) {
      brandList = List.generate(
        snapshot.docs.length,
        (index) => Brand.fromJson(
          snapshot.docs[index].data(),
        ),
      );
      notifyListeners();
    });
  }

  Future<ImageModel> uploadImage(String imageLocalPath) async {
    final String imageName = 'image_${DateTime.now().millisecondsSinceEpoch}';
    final photoRef = FirebaseStorage.instance
        .ref()
        .child('$telescopeImageDirectory$imageName');
    final uploadTask = photoRef.putFile(File(imageLocalPath));
    final snapshot = await uploadTask.whenComplete(() => null);
    final url = await snapshot.ref.getDownloadURL();
    return ImageModel(
      imageName: imageName,
      directoryName: telescopeImageDirectory,
      downloadUrl: url,
    );
  }

  Future<void> addTelescope(Telescope telescope) {
    return DbHelper.addTelescope(telescope);
  }

  void getAllTelescopes() {
    DbHelper.getAllTelescopes().listen((snapshot) {
      telescopeList = List.generate(
        snapshot.docs.length,
        (index) => Telescope.fromJson(
          snapshot.docs[index].data(),
        ),
      );
      notifyListeners();
    });
  }

  Telescope findTelescopeById(String id) {
    return telescopeList.firstWhere((element) => element.id == id);
  }

  Future<void> updateTelescopeField(
      String id, String field, dynamic value) async {
    return DbHelper.updateTelescopeField(id, <String, dynamic>{field: value});
  }

  Future<void> deleteImage(String id, ImageModel image) async {
    final photoRef = FirebaseStorage.instance
        .ref()
        .child('${image.directoryName}${image.imageName}');
    return photoRef.delete();
  }
}
