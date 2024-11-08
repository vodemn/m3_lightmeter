import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/screens/equipment_profile_edit/bloc_equipment_profile_edit.dart';
import 'package:lightmeter/screens/equipment_profile_edit/screen_equipment_profile_edit.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

enum EquipmentProfileEditType { add, edit }

class EquipmentProfileEditArgs {
  final EquipmentProfileEditType editType;
  final EquipmentProfile? profile;

  const EquipmentProfileEditArgs({required this.editType, this.profile});
}

class EquipmentProfileEditFlow extends StatelessWidget {
  final EquipmentProfileEditArgs args;
  final bool _isEdit;

  EquipmentProfileEditFlow({
    required this.args,
    super.key,
  }) : _isEdit = args.editType == EquipmentProfileEditType.edit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EquipmentProfileEditBloc(
        EquipmentProfilesProvider.of(context),
        profile: args.profile,
        isEdit: _isEdit,
      ),
      child: EquipmentProfileEditScreen(isEdit: _isEdit),
    );
  }
}
