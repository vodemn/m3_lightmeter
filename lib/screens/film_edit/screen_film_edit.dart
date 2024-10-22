import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/film_edit/bloc_film_edit.dart';
import 'package:lightmeter/screens/film_edit/components/exponential_formula_input/widget_input_exponential_formula.dart';
import 'package:lightmeter/screens/film_edit/event_film_edit.dart';
import 'package:lightmeter/screens/film_edit/state_film_edit.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/components/dialog_picker/widget_picker_dialog.dart';
import 'package:lightmeter/screens/shared/sliver_screen/screen_sliver.dart';
import 'package:lightmeter/screens/shared/text_field/widget_text_field.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class FilmEditScreen extends StatefulWidget {
  const FilmEditScreen({super.key});

  @override
  State<FilmEditScreen> createState() => _FilmEditScreenState();
}

class _FilmEditScreenState extends State<FilmEditScreen> {
  @override
  Widget build(BuildContext context) {
    return SliverScreen(
      title: BlocBuilder<FilmEditBloc, FilmEditState>(
        buildWhen: (previous, current) => previous.name != current.name,
        builder: (_, state) => Text(state.name),
      ),
      appBarActions: [
        BlocBuilder<FilmEditBloc, FilmEditState>(
          buildWhen: (previous, current) => previous.canSave != current.canSave,
          builder: (context, state) => IconButton(
            onPressed: state.canSave ? () {} : null,
            icon: const Icon(Icons.save),
          ),
        ),
      ],
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Dimens.paddingM,
              0,
              Dimens.paddingM,
              Dimens.paddingM,
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimens.paddingM),
                child: Column(
                  children: [
                    _NameFieldBuilder(),
                    BlocBuilder<FilmEditBloc, FilmEditState>(
                      buildWhen: (previous, current) => previous.isoValue != current.isoValue,
                      builder: (context, state) => _IsoPickerListTile(
                        selected: state.isoValue,
                        onChanged: (value) {
                          context.read<FilmEditBloc>().add(FilmEditIsoChangedEvent(value));
                        },
                      ),
                    ),
                    BlocBuilder<FilmEditBloc, FilmEditState>(
                      buildWhen: (previous, current) => previous.exponent != current.exponent,
                      builder: (context, state) => ExponentialFormulaInput(
                        value: state.exponent,
                        onChanged: (value) {
                          context.read<FilmEditBloc>().add(FilmEditExpChangedEvent(value));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: MediaQuery.paddingOf(context).bottom)),
      ],
    );
  }
}

class _NameFieldBuilder extends StatelessWidget {
  const _NameFieldBuilder();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Dimens.paddingM,
        top: Dimens.paddingS / 2,
        right: Dimens.paddingL,
        bottom: Dimens.paddingS / 2,
      ),
      child: BlocBuilder<FilmEditBloc, FilmEditState>(
        buildWhen: (previous, current) => previous.name != current.name,
        builder: (context, state) => LightmeterTextField(
          initialValue: state.name,
          onChanged: (value) {
            context.read<FilmEditBloc>().add(FilmEditNameChangedEvent(value));
          },
          style: Theme.of(context).listTileTheme.titleTextStyle,
          leading: const Icon(Icons.edit_outlined),
        ),
      ),
    );
  }
}

class _IsoPickerListTile extends StatelessWidget {
  final IsoValue selected;
  final ValueChanged<IsoValue> onChanged;

  const _IsoPickerListTile({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.iso),
      title: Text(S.of(context).iso),
      trailing: Text(selected.value.toString()),
      onTap: () {
        showDialog<IsoValue>(
          context: context,
          builder: (_) => Dialog(
            child: DialogPicker<IsoValue>(
              icon: Icons.iso,
              title: S.of(context).iso,
              subtitle: S.of(context).filmSpeed,
              values: IsoValue.values,
              initialValue: selected,
              itemTitleBuilder: (_, value) => Text(value.value.toString()),
              onSelect: (value) {
                onChanged(value);
                Navigator.of(context).pop();
              },
              onCancel: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }
}
