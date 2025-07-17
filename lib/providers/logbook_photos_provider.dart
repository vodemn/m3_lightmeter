import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lightmeter/data/geolocation_service.dart';
import 'package:lightmeter/platform_config.dart';
import 'package:lightmeter/utils/context_utils.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:uuid/v8.dart';

class LogbookPhotosProvider extends StatefulWidget {
  final IapStorageService storageService;
  final GeolocationService geolocationService;
  final VoidCallback? onInitialized;
  final Widget child;

  const LogbookPhotosProvider({
    required this.storageService,
    required this.geolocationService,
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
  bool _isEnabled = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return LogbookPhotos(
      photos: context.isPro ? _photos.values.toList(growable: false) : [],
      isEnabled: _isEnabled,
      child: widget.child,
    );
  }

  void saveLogbookPhotos(bool save) {
    setState(() {
      _isEnabled = save;
    });
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

  Future<LogbookPhoto?> addPhotoIfPossible(
    String path, {
    required double ev100,
    required int iso,
    required int nd,
  }) async {
    if (context.isPro && _isEnabled) {
      final coordinates = await widget.geolocationService.getCurrentPosition();

      final photo = LogbookPhoto(
        id: const UuidV8().generate(),
        name: path,
        timestamp: DateTime.timestamp(),
        ev: ev100,
        iso: iso,
        nd: nd,
        coordinates: coordinates,
      );
      await widget.storageService.addPhoto(photo);
      _photos[photo.id] = photo;
      setState(() {});
      return photo;
    } else {
      _deletePhoto(path);
      return null;
    }
  }

  Future<void> updateLogbookPhoto(LogbookPhoto photo) async {
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

  Future<void> deleteLogbookPhoto(LogbookPhoto photo) async {
    await widget.storageService.deletePhoto(photo.id);
    _photos.remove(photo.id);
    _deletePhoto(photo.name);
    setState(() {});
  }

  Future<void> _deletePhoto(String path) async {
    if (PlatformConfig.cameraStubImage.isEmpty) {
      try {
        Directory(path).deleteSync(recursive: true);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }
}

enum _LogbookPhotosModelAspect { photosList, isEnabled }

class LogbookPhotos extends InheritedModel<_LogbookPhotosModelAspect> {
  final List<LogbookPhoto> photos;
  final bool isEnabled;

  const LogbookPhotos({
    required this.photos,
    required this.isEnabled,
    required super.child,
  });

  static List<LogbookPhoto> of(BuildContext context, {bool listen = true}) {
    return (listen
            ? InheritedModel.inheritFrom<LogbookPhotos>(context, aspect: _LogbookPhotosModelAspect.photosList)
            : context.getInheritedWidgetOfExactType<LogbookPhotos>())!
        .photos;
  }

  static bool isEnabledOf(BuildContext context, {bool listen = true}) {
    return (listen
            ? InheritedModel.inheritFrom<LogbookPhotos>(context, aspect: _LogbookPhotosModelAspect.isEnabled)
            : context.getInheritedWidgetOfExactType<LogbookPhotos>())!
        .isEnabled;
  }

  @override
  bool updateShouldNotify(LogbookPhotos oldWidget) =>
      !const DeepCollectionEquality().equals(oldWidget.photos, photos) || oldWidget.isEnabled != isEnabled;

  @override
  bool updateShouldNotifyDependent(LogbookPhotos oldWidget, Set<_LogbookPhotosModelAspect> aspects) {
    if (aspects.contains(_LogbookPhotosModelAspect.photosList) &&
        !const DeepCollectionEquality().equals(oldWidget.photos, photos)) {
      return true;
    }
    if (aspects.contains(_LogbookPhotosModelAspect.isEnabled) && oldWidget.isEnabled != isEnabled) {
      return true;
    }
    return false;
  }
}
