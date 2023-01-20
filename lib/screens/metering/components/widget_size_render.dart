import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ReadingsContainer extends SingleChildRenderObjectWidget {
  final ValueChanged<Size>? onLayout;

  const ReadingsContainer({
    super.key,
    super.child,
    this.onLayout,
  });

  @override
  RenderReadingsContainer createRenderObject(BuildContext context) => RenderReadingsContainer(onLayout: onLayout);
}

class RenderReadingsContainer extends RenderProxyBox {
  final ValueChanged<Size>? onLayout;

  RenderReadingsContainer({this.onLayout});

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
