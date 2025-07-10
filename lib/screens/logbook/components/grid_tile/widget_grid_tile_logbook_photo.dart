import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class LogbookPhotoGridTile extends StatelessWidget {
  final LogbookPhoto photo;
  final VoidCallback onTap;

  const LogbookPhotoGridTile({
    required this.photo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.borderRadiusM)),
        child: FadeInImage(
          placeholder: MemoryImage(Uint8List(0)), // Will be replaced by placeholder widget
          image: FileImage(File(photo.name)),
          fit: BoxFit.cover,
          fadeInDuration: Dimens.durationS,
          fadeOutDuration: Dimens.durationS,
          imageErrorBuilder: (_, __, ___) => const Center(child: Icon(Icons.error_outline)),
          placeholderErrorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
