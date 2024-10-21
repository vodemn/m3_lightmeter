import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/film_edit/bloc_film_edit.dart';
import 'package:lightmeter/screens/film_edit/event_film_edit.dart';
import 'package:lightmeter/screens/film_edit/state_film_edit.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/components/dialog_picker/widget_picker_dialog.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_filter/widget_dialog_filter.dart';
import 'package:lightmeter/screens/settings/components/shared/expandable_section_list/widget_expandable_section_list.dart';
import 'package:lightmeter/screens/shared/sliver_screen/screen_sliver.dart';
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
        buildWhen: (previous, current) => previous.film.name != current.film.name,
        builder: (context, state) => TextFormField(
          initialValue: state.film.name,
          onChanged: (value) {},
        ),
      ),
      appBarActions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.save),
        ),
      ],
      slivers: [
        SliverToBoxAdapter(
          child: BlocBuilder<FilmEditBloc, FilmEditState>(
            buildWhen: (previous, current) => previous.isoValue != current.isoValue,
            builder: (context, state) => _IsoPickerListTile(
              selected: state.isoValue,
              onChanged: (value) {
                context.read<FilmEditBloc>().add(FilmEditIsoChangedEvent(value));
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: BlocBuilder<FilmEditBloc, FilmEditState>(
            buildWhen: (previous, current) => previous.film.exponent != current.film.exponent,
            builder: (context, state) => ListTile(
              leading: const Icon(Icons.equalizer),
              title: Text('Formula'),
              trailing: Text(state.film.exponent.toString()),
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: MediaQuery.paddingOf(context).bottom)),
      ],
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
