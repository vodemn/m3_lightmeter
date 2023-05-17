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

// class InheritedModelBase<A, R> extends InheritedModel<A> {
//   final Map<A, R> data;

//   const InheritedModelBase({
//     required this.data,
//     required super.child,
//     super.key,
//   });

//   static Map<A, R> of<R, A>(BuildContext context, {bool listen = true}) {
//     if (listen) {
//       return context.dependOnInheritedWidgetOfExactType<InheritedModelBase<A, R>>()!.data;
//     } else {
//       return context.findAncestorWidgetOfExactType<InheritedModelBase<A, R>>()!.data;
//     }
//   }

//   static R featureStatusOf<A, R>(BuildContext context, A aspect) {
//     return InheritedModel.inheritFrom<InheritedModelBase<A, R>>(context, aspect: aspect)!
//         .data[aspect]!;
//   }

//   @override
//   bool updateShouldNotify(InheritedModelBase oldWidget) => true;

//   @override
//   bool updateShouldNotifyDependent(
//     InheritedModelBase<A, R> oldWidget,
//     Set<A> dependencies,
//   ) {
//     for (final dependecy in dependencies) {
//       if (oldWidget.data[dependecy] != data[dependecy]) {
//         return true;
//       }
//     }
//     return false;
//   }
// }

extension InheritedWidgetBaseContext on BuildContext {
  T get<T>() {
    return InheritedWidgetBase.of<T>(this, listen: false);
  }

  T listen<T>() {
    return InheritedWidgetBase.of<T>(this);
  }
}
