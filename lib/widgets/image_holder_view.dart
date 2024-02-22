import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/image_model.dart';

class ImageHolderView extends StatelessWidget {
  final ImageModel imageModel;
  final VoidCallback onImagePressed;

  const ImageHolderView({
    super.key,
    required this.imageModel,
    required this.onImagePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: 80,
      height: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onImagePressed,
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: imageModel.downloadUrl,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
