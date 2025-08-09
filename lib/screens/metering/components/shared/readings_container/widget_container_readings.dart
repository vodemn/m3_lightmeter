import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/data/models/feature.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/providers/remote_config_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/equipment_profile_picker/widget_picker_equipment_profiles.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/extreme_exposure_pairs_container/widget_container_extreme_exposure_pairs.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/film_picker/widget_picker_film.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/iso_picker/widget_picker_iso.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/lightmeter_pro/widget_lightmeter_pro.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/nd_picker/widget_picker_nd.dart';
import 'package:lightmeter/utils/context_utils.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class ReadingsContainer extends StatelessWidget {
  final ExposurePair? fastest;
  final ExposurePair? slowest;
  final IsoValue iso;
  final NdValue nd;
  final ValueChanged<IsoValue> onIsoChanged;
  final ValueChanged<NdValue> onNdChanged;

  const ReadingsContainer({
    required this.fastest,
    required this.slowest,
    required this.iso,
    required this.nd,
    required this.onIsoChanged,
    required this.onNdChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!context.isPro && RemoteConfig.isEnabled(context, Feature.showUnlockProOnMainScreen)) ...[
          const LightmeterProAnimatedDialog(),
          const _InnerPadding(),
        ],
        if (context.meteringFeature(MeteringScreenLayoutFeature.equipmentProfiles)) ...[
          const EquipmentProfilePicker(),
          const _InnerPadding(),
        ],
        if (context.meteringFeature(MeteringScreenLayoutFeature.extremeExposurePairs)) ...[
          ExtremeExposurePairsContainer(
            fastest: fastest,
            slowest: slowest,
          ),
          const _InnerPadding(),
        ],
        if (context.meteringFeature(MeteringScreenLayoutFeature.filmPicker)) ...[
          FilmPicker(selectedIso: iso),
          const _InnerPadding(),
        ],
        Row(
          children: [
            Expanded(
              child: IsoValuePicker(
                selectedValue: iso,
                values: EquipmentProfiles.selectedOf(context).isoValues,
                onChanged: onIsoChanged,
              ),
            ),
            const _InnerPadding(),
            Expanded(
              child: NdValuePicker(
                selectedValue: nd,
                values: EquipmentProfiles.selectedOf(context).ndValues,
                onChanged: onNdChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InnerPadding extends SizedBox {
  const _InnerPadding() : super(height: Dimens.grid8, width: Dimens.grid8);
}
