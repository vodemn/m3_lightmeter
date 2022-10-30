import 'package:flutter/material.dart';
import 'package:lightmeter/models/photography_value.dart';
import 'package:provider/provider.dart';

class StopTypeProvider extends StatefulWidget {
  final Widget? child;

  const StopTypeProvider({this.child, super.key});

  @override
  State<StopTypeProvider> createState() => StopTypeProviderState();
}

class StopTypeProviderState extends State<StopTypeProvider> {
  StopType stopType = StopType.full;

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: stopType,
      child: Provider.value(
        value: this,
        child: widget.child,
      ),
    );
  }

  void setStopType(StopType type) {
    setState(() {
      stopType = type;
    });
  }
}
