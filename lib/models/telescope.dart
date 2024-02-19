import 'package:flutter_firebase/models/brand.dart';
import 'package:flutter_firebase/models/image_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'telescope.freezed.dart';
part 'telescope.g.dart';

@unfreezed
class Telescope with _$Telescope {
  factory Telescope({
    String? id,
    required String model,
    required Brand brand,
    required String type,
    required String dimension,
    required num weightInPound,
    required String focustype,
    required num lensDiameterInMM,
    required String mountDescription,
    required num price,
    required num stock,
    required num avgRating,
    required num discount,
    required ImageModel thumbnail,
    required List<ImageModel> additionalImages,
    String? description,
  }) = _Telescope;

  factory Telescope.fromJson(Map<String, dynamic> json) =>
      _$TelescopeFromJson(json);
}
