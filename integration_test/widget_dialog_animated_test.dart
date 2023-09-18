import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lightmeter/data/models/film.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/animated_dialog_picker/widget_picker_dialog_animated.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/reading_value_container/widget_container_reading_value.dart';

import 'mocks/application_mock.dart';

void main() {
  runApp(const ApplicationMock(child: AnimatedPickerTest()));
}

void main2() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('AnimatedDialogPicker test', () {
    testWidgets('Tap on `ReadingValueContainer`, verify opened', (tester) async {
      await tester.pumpWidget(const ApplicationMock(child: AnimatedPickerTest()));
      expect(find.text('Film'), findsOneWidget);
      expect(find.text('None'), findsOneWidget);

      await binding.traceAction(
        () async {
          await tester.tap(find.byType(AnimatedDialogPicker<Film>));
          await tester.pumpAndSettle(Dimens.durationL);
        },
        reportKey: 'dialog_opening_timeline',
      );

      expect(find.text('Film'), findsNWidgets(3));
      expect(find.text('None'), findsNWidgets(3));
    });
  });
}

class AnimatedPickerTest extends StatefulWidget {
  const AnimatedPickerTest({super.key});

  @override
  State<AnimatedPickerTest> createState() => _AnimatedPickerTestState();
}

class _AnimatedPickerTestState extends State<AnimatedPickerTest> {
  Film _selectedFilm = Film.values.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _FilmPicker(
          values: Film.values,
          selectedValue: _selectedFilm,
          onChanged: (value) {
            setState(() {
              _selectedFilm = value;
            });
          },
        ),
      ),
    );
  }
}

class _FilmPicker extends StatelessWidget {
  final List<Film> values;
  final Film selectedValue;
  final ValueChanged<Film> onChanged;

  const _FilmPicker({
    required this.values,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedDialogPicker<Film>(
      icon: Icons.camera_roll,
      title: "Film",
      selectedValue: selectedValue,
      values: values,
      itemTitleBuilder: (_, value) => Text(value.name.isEmpty ? 'None' : value.name),
      onChanged: onChanged,
      closedChild: ReadingValueContainer.singleValue(
        value: ReadingValue(
          label: "Film",
          value: selectedValue.name.isEmpty ? 'None' : selectedValue.name,
        ),
      ),
    );
  }
}
