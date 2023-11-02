
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/utils/selectable_provider.dart';

void main() {
  group('SelectableInheritedModel.updateShouldNotifyDependent', () {
    final model = SelectableInheritedModel<int>(
      values: List.generate(25, (index) => index),
      selected: 1,
      child: const SizedBox(),
    );

    test(
      '`{}`',
      () {
        expect(
          model.updateShouldNotifyDependent(
            SelectableInheritedModel<int>(
              values: List.generate(25, (index) => index),
              selected: 1,
              child: const SizedBox(),
            ),
            {},
          ),
          false,
        );
      },
    );

    test(
      '`{SelectableAspect.list}`',
      () {
        expect(
          model.updateShouldNotifyDependent(
            SelectableInheritedModel<int>(
              values: List.generate(25, (index) => index),
              selected: 1,
              child: const SizedBox(),
            ),
            {SelectableAspect.list},
          ),
          true,
        );
      },
    );

    test(
      '`{SelectableAspect.selected}`',
      () {
        expect(
          model.updateShouldNotifyDependent(
            SelectableInheritedModel<int>(
              values: List.generate(25, (index) => index),
              selected: 1,
              child: const SizedBox(),
            ),
            {SelectableAspect.selected},
          ),
          false,
        );
        expect(
          model.updateShouldNotifyDependent(
            SelectableInheritedModel<int>(
              values: List.generate(25, (index) => index),
              selected: 2,
              child: const SizedBox(),
            ),
            {SelectableAspect.selected},
          ),
          true,
        );
      },
    );
  });
}
