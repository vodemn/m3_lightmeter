import 'package:flutter/material.dart';

enum SelectableAspect { list, selected }

class SelectableInheritedModel<T> extends InheritedModel<SelectableAspect> {
  const SelectableInheritedModel({
    super.key,
    required this.values,
    required this.selected,
    required super.child,
  });

  final List<T> values;
  final T selected;

  static List<T> of<T>(BuildContext context) {
    return InheritedModel.inheritFrom<SelectableInheritedModel<T>>(
      context,
      aspect: SelectableAspect.list,
    )!
        .values;
  }

  static T selectedOf<T>(BuildContext context) {
    return InheritedModel.inheritFrom<SelectableInheritedModel>(
      context,
      aspect: SelectableAspect.selected,
    )!
        .selected;
  }

  @override
  bool updateShouldNotify(SelectableInheritedModel oldWidget) => true;

  @override
  bool updateShouldNotifyDependent(SelectableInheritedModel oldWidget, Set<SelectableAspect> dependencies) {
    if (dependencies.contains(SelectableAspect.list)) {
      return true;
    } else if (dependencies.contains(SelectableAspect.selected)) {
      return selected != oldWidget.selected;
    } else {
      return false;
    }
  }
}
