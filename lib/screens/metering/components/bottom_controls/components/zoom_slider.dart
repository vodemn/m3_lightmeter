import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';

class ZoomSlider extends StatelessWidget {
  const ZoomSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingL),
      child: Row(
        children: [
          const Icon(Icons.zoom_out),
          Expanded(
            child: Slider(
              value: 0,
              onChanged: (value) {},
            ),
          ),
          const Icon(Icons.zoom_in),
        ],
      ),
    );
  }
}
