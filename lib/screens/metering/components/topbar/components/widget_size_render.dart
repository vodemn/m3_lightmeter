import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SizeRenderWidget extends SingleChildRenderObjectWidget {
  final ValueChanged<Size>? onLayout;

  const SizeRenderWidget({
    super.key,
    super.child,
    this.onLayout,
  });

  @override
  SizeRenderBox createRenderObject(BuildContext context) => SizeRenderBox(onLayout: onLayout);
}

class SizeRenderBox extends RenderProxyBox {
  final ValueChanged<Size>? onLayout;

  SizeRenderBox({this.onLayout});

  @override
  void performLayout() {
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
      size = child!.size;
    } else {
      size = computeSizeForNoChild(constraints);
    }
    onLayout?.call(size);
  }
}
