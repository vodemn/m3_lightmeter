import 'package:flutter/material.dart';

class MapModel<T> extends InheritedModel<T> {
  final Map<T, bool> data;

  const MapModel({
    required this.data,
    required super.child,
  });

  @override
  bool updateShouldNotify(MapModel oldWidget) => oldWidget.data != data;

  @override
  bool updateShouldNotifyDependent(
    MapModel<T> oldWidget,
    Set<T> dependencies,
  ) {
    for (final dependecy in dependencies) {
      if (oldWidget.data[dependecy] != data[dependecy]) {
        return true;
      }
    }
    return false;
  }
}
