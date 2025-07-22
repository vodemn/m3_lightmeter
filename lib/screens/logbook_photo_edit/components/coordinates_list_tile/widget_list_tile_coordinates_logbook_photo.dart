import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/logbook_photo_edit/bloc_logbook_photo_edit.dart';
import 'package:lightmeter/screens/logbook_photo_edit/state_logbook_photo_edit.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class LogbookPhotoCoordinatesListTile extends StatefulWidget {
  const LogbookPhotoCoordinatesListTile();

  @override
  State<LogbookPhotoCoordinatesListTile> createState() => LogbookPhotoCoordinatesListTileState();
}

class LogbookPhotoCoordinatesListTileState extends State<LogbookPhotoCoordinatesListTile> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogbookPhotoEditBloc, LogbookPhotoEditState>(
      buildWhen: (previous, current) => previous.note != current.note,
      builder: (context, state) {
        final coords = state.coordinates;
        final hasCoords = coords != null;
        final text = hasCoords ? '${coords.latitude.toStringAsFixed(6)}, ${coords.longitude.toStringAsFixed(6)}' : '-';
        return ListTile(
          leading: const Icon(Icons.location_on_outlined),
          title: Text(S.of(context).location),
          trailing: Text(text),
          onTap: hasCoords
              ? () async {
                  final lat = coords.latitude;
                  final lng = coords.longitude;
                  final availableMaps = await MapLauncher.installedMaps;
                  if (availableMaps.isEmpty) {
                    // Fallback to Google Maps in browser
                    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } else if (mounted) {
                      _showSnackBar();
                    }
                    return;
                  }
                  await MapLauncher.showMarker(
                    mapType: availableMaps.first.mapType,
                    coords: Coords(lat, lng),
                    title: text,
                    description: state.note,
                  );
                }
              : null,
        );
      },
    );
  }

  Future<void> _showSnackBar() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).youDontHaveMailApp),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
