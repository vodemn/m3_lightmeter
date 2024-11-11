import 'package:flutter/widgets.dart';

extension ModalRouteArgsParser on BuildContext {
  T routeArgs<T>() {
    return ModalRoute.of(this)!.settings.arguments! as T;
  }
}
