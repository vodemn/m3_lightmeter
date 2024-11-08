import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/film_edit/bloc_film_edit.dart';
import 'package:lightmeter/screens/film_edit/components/exponential_formula_input/widget_input_exponential_formula_film_edit.dart';
import 'package:lightmeter/screens/film_edit/components/iso_picker/widget_picker_iso_film_edit.dart';
import 'package:lightmeter/screens/film_edit/components/name_field/widget_field_name_film_edit.dart';
import 'package:lightmeter/screens/film_edit/event_film_edit.dart';
import 'package:lightmeter/screens/film_edit/state_film_edit.dart';
import 'package:lightmeter/screens/shared/sliver_screen/screen_sliver.dart';

class FilmEditScreen extends StatefulWidget {
  final bool isEdit;

  const FilmEditScreen({
    required this.isEdit,
    super.key,
  });

  @override
  State<FilmEditScreen> createState() => _FilmEditScreenState();
}

class _FilmEditScreenState extends State<FilmEditScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FilmEditBloc, FilmEditState>(
      listenWhen: (previous, current) => previous.isLoading != current.isLoading,
      listener: (context, state) {
        if (state.isLoading) {
          FocusScope.of(context).unfocus();
        } else {
          Navigator.of(context).pop();
        }
      },
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) => IgnorePointer(
        ignoring: state.isLoading,
        child: SliverScreen(
          title: Text(widget.isEdit ? S.of(context).editFilmTitle : S.of(context).addFilmTitle),
          appBarActions: [
            BlocBuilder<FilmEditBloc, FilmEditState>(
              buildWhen: (previous, current) => previous.canSave != current.canSave,
              builder: (context, state) => IconButton(
                onPressed: state.canSave
                    ? () {
                        context.read<FilmEditBloc>().add(const FilmEditSaveEvent());
                      }
                    : null,
                icon: const Icon(Icons.save_outlined),
              ),
            ),
            if (widget.isEdit)
              IconButton(
                onPressed: () {
                  context.read<FilmEditBloc>().add(const FilmEditDeleteEvent());
                },
                icon: const Icon(Icons.delete_outline),
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
                    child: Opacity(
                      opacity: state.isLoading ? Dimens.disabledOpacity : Dimens.enabledOpacity,
                      child: Column(
                        children: [
                          BlocBuilder<FilmEditBloc, FilmEditState>(
                            buildWhen: (previous, current) => previous.name != current.name,
                            builder: (context, state) => FilmEditNameField(
                              name: state.name,
                              onChanged: (value) {
                                context.read<FilmEditBloc>().add(FilmEditNameChangedEvent(value));
                              },
                            ),
                          ),
                          BlocBuilder<FilmEditBloc, FilmEditState>(
                            buildWhen: (previous, current) => previous.isoValue != current.isoValue,
                            builder: (context, state) => FilmEditIsoPicker(
                              selected: state.isoValue,
                              onChanged: (value) {
                                context.read<FilmEditBloc>().add(FilmEditIsoChangedEvent(value));
                              },
                            ),
                          ),
                          BlocBuilder<FilmEditBloc, FilmEditState>(
                            buildWhen: (previous, current) => previous.exponent != current.exponent,
                            builder: (context, state) => FilmEditExponentialFormulaInput(
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
            ),
            SliverToBoxAdapter(child: SizedBox(height: MediaQuery.paddingOf(context).bottom)),
          ],
        ),
      ),
    );
  }
}
