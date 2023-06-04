import 'package:flutter/widgets.dart';

/// Listening to multiple dependencies at the same time causes firing an event for all dependencies
/// even though some of them didn't change:
/// ```dart
/// @override
/// void didChangeDependencies() {
///   super.didChangeDependencies();
///   _bloc.add(EquipmentProfileChangedEvent(EquipmentProfile.of(context)));
///   if (!MeteringScreenLayout.featureStatusOf(context, MeteringScreenLayoutFeature.filmPicker)) {
///     _bloc.add(const FilmChangedEvent(Film.other()));
///   }
/// }
/// ```
/// To overcome this issue I've decided to create a generic listener,
/// that will listen to each dependency separately.
class InheritedWidgetListener<T> extends StatefulWidget {
  final ValueChanged<T> onDidChangeDependencies;
  final Widget child;

  const InheritedWidgetListener({
    required this.onDidChangeDependencies,
    required this.child,
    super.key,
  });

  @override
  State<InheritedWidgetListener<T>> createState() => _InheritedWidgetListenerState<T>();
}

class _InheritedWidgetListenerState<T> extends State<InheritedWidgetListener<T>> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.onDidChangeDependencies(context.listen<T>());
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class InheritedWidgetBase<T> extends InheritedWidget {
  final T data;

  const InheritedWidgetBase({
    required this.data,
    required super.child,
    super.key,
  });

  static T of<T>(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<InheritedWidgetBase<T>>()!.data;
    } else {
      return context.findAncestorWidgetOfExactType<InheritedWidgetBase<T>>()!.data;
    }
  }

  @override
  bool updateShouldNotify(InheritedWidgetBase<T> oldWidget) => true;
}

extension InheritedWidgetBaseContext on BuildContext {
  T get<T>() {
    return InheritedWidgetBase.of<T>(this, listen: false);
  }

  T listen<T>() {
    return InheritedWidgetBase.of<T>(this);
  }
}

/// Listening to multiple dependencies at the same time causes firing an event for all dependencies
/// even though some of them didn't change:
/// ```dart
/// @override
/// void didChangeDependencies() {
///   super.didChangeDependencies();
///   _bloc.add(EquipmentProfileChangedEvent(EquipmentProfile.of(context)));
///   if (!MeteringScreenLayout.featureStatusOf(context, MeteringScreenLayoutFeature.filmPicker)) {
///     _bloc.add(const FilmChangedEvent(Film.other()));
///   }
/// }
/// ```
/// To overcome this issue I've decided to create a generic listener,
/// that will listen to each dependency separately.
class InheritedModelAspectListener<A extends Object, T> extends StatefulWidget {
  final A aspect;
  final ValueChanged<T> onDidChangeDependencies;
  final Widget child;

  const InheritedModelAspectListener({
    required this.aspect,
    required this.onDidChangeDependencies,
    required this.child,
    super.key,
  });

  @override
  State<InheritedModelAspectListener<A, T>> createState() =>
      _InheritedModelAspectListenerState<A, T>();
}

class _InheritedModelAspectListenerState<A extends Object, T>
    extends State<InheritedModelAspectListener<A, T>> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.onDidChangeDependencies(context.listenModelFeature<A, T>(widget.aspect));
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class InheritedModelBase<A, T> extends InheritedModel<A> {
  final Map<A, T> data;

  const InheritedModelBase({
    required this.data,
    required super.child,
    super.key,
  });

  static Map<A, T> of<A, T>(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<InheritedModelBase<A, T>>()!.data;
    } else {
      return context.findAncestorWidgetOfExactType<InheritedModelBase<A, T>>()!.data;
    }
  }

  static T featureOf<A extends Object, T>(BuildContext context, A aspect) {
    return InheritedModel.inheritFrom<InheritedModelBase<A, T>>(context, aspect: aspect)!
        .data[aspect]!;
  }

  @override
  bool updateShouldNotify(InheritedModelBase oldWidget) => true;

  @override
  bool updateShouldNotifyDependent(
    InheritedModelBase<A, T> oldWidget,
    Set<A> dependencies,
  ) {
    for (final dependecy in dependencies) {
      if (oldWidget.data[dependecy] != data[dependecy]) {
        return true;
      }
    }
    return false;
  }
}

extension InheritedModelBaseContext on BuildContext {
  Map<A, T> getModel<A, T>() {
    return InheritedModelBase.of<A, T>(this, listen: false);
  }

  Map<A, T> listenModel<A, T>() {
    return InheritedModelBase.of<A, T>(this);
  }

  T listenModelFeature<A extends Object, T>(A aspect) {
    return InheritedModelBase.featureOf<A, T>(this, aspect);
  }
}
