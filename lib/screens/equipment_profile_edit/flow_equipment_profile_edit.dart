import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/screens/equipment_profile_edit/bloc_equipment_profile_edit.dart';
import 'package:lightmeter/screens/equipment_profile_edit/screen_equipment_profile_edit.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class EquipmentProfileEditArgs {
  final EquipmentProfile? profile;

  const EquipmentProfileEditArgs({this.profile});
}

class EquipmentProfileEditFlow extends StatelessWidget {
  final EquipmentProfileEditArgs args;

  const EquipmentProfileEditFlow({required this.args, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EquipmentProfileEditBloc(
        EquipmentProfileProvider.of(context),
        profile: args.profile,
        isEdit: args.profile != null,
      ),
      child: EquipmentProfileEditScreen(isEdit: args.profile != null),
    );
  }
}
