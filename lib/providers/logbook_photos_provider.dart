import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lightmeter/providers/films_provider.dart';
import 'package:lightmeter/utils/context_utils.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:uuid/v8.dart';

class LogbookPhotosProvider extends StatefulWidget {
  final LogbookPhotosStorageService storageService;
  final VoidCallback? onInitialized;
  final Widget child;

  const LogbookPhotosProvider({
    required this.storageService,
    this.onInitialized,
    required this.child,
    super.key,
  });

  static LogbookPhotosProviderState of(BuildContext context) {
    return context.findAncestorStateOfType<LogbookPhotosProviderState>()!;
  }

  @override
  State<LogbookPhotosProvider> createState() => LogbookPhotosProviderState();
}

class LogbookPhotosProviderState extends State<LogbookPhotosProvider> {
  final Map<String, LogbookPhoto> _photos = {};

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return LogbookPhotos(
      photos: context.isPro ? _photos.values.toList(growable: false) : [],
      child: widget.child,
    );
  }

  Future<void> _init() async {
    _photos.addAll(
      Map.fromIterable(
        await widget.storageService.getPhotos(),
        key: (photo) => (photo as LogbookPhoto).id,
      ),
    );
    if (mounted) setState(() {});
    widget.onInitialized?.call();
  }

  Future<void> addPhotoIfPossible(
    String path, {
    required double ev100,
    required int iso,
    required int nd,
  }) async {
    if (context.isPro) {
      final photo = LogbookPhoto(
        id: const UuidV8().generate(),
        name: path,
        timestamp: DateTime.timestamp(),
        ev: ev100,
        iso: iso,
        nd: nd,
        coordinates: null, // TODO
      );
      //await widget.storageService.addPhoto(photo);
      _photos[photo.id] = photo;
      setState(() {});
    } else {
      Directory(path).deleteSync(recursive: true);
    }
  }

  Future<void> updateProfile(LogbookPhoto photo) async {
    final oldProfile = _photos[photo.id]!;
    await widget.storageService.updatePhoto(
      id: photo.id,
      note: oldProfile.note != photo.note ? photo.note : null,
      apertureValue: oldProfile.apertureValue != photo.apertureValue ? photo.apertureValue : null,
      removeApertureValue: photo.apertureValue == null,
      shutterSpeedValue: oldProfile.shutterSpeedValue != photo.shutterSpeedValue ? photo.shutterSpeedValue : null,
      removeShutterSpeedValue: photo.shutterSpeedValue == null,
    );
    _photos[photo.id] = photo;
    setState(() {});
  }

  Future<void> deleteProfile(LogbookPhoto photo) async {
    await widget.storageService.deletePhoto(photo.id);
    _photos.remove(photo.id);
    Directory(photo.name).deleteSync(recursive: true);
    setState(() {});
  }
}

class LogbookPhotos extends InheritedWidget {
  final List<LogbookPhoto> photos;

  const LogbookPhotos({
    required this.photos,
    required super.child,
  });

  static List<LogbookPhoto> of(BuildContext context, {bool listen = false}) {
    return (listen
            ? context.dependOnInheritedWidgetOfExactType<LogbookPhotos>()
            : context.getInheritedWidgetOfExactType<LogbookPhotos>())!
        .photos;
  }

  @override
  bool updateShouldNotify(LogbookPhotos oldWidget) => const DeepCollectionEquality().equals(oldWidget.photos, photos);
}
