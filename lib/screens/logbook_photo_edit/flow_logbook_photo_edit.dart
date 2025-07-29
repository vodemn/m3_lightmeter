import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/providers/logbook_photos_provider.dart';
import 'package:lightmeter/screens/logbook_photo_edit/bloc_logbook_photo_edit.dart';
import 'package:lightmeter/screens/logbook_photo_edit/screen_logbook_photo_edit.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class LogbookPhotoEditArgs {
  final LogbookPhoto photo;

  const LogbookPhotoEditArgs({required this.photo});
}

class LogbookPhotoEditFlow extends StatelessWidget {
  final LogbookPhotoEditArgs args;

  const LogbookPhotoEditFlow({
    required this.args,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LogbookPhotoEditBloc(
        LogbookPhotosProvider.of(context),
        args.photo,
      ),
      child: const LogbookPhotoEditScreen(),
    );
  }
}
