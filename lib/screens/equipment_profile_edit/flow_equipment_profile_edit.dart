import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/screens/equipment_profile_edit/bloc_equipment_profile_edit.dart';
import 'package:lightmeter/screens/equipment_profile_edit/screen_equipment_profile_edit.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

enum EquipmentProfileEditType { add, edit }

class EquipmentProfileEditArgs<T extends IEquipmentProfile> {
  final EquipmentProfileEditType editType;
  final T profile;

  const EquipmentProfileEditArgs({
    required this.editType,
    required this.profile,
  });
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
    switch (args.profile) {
      case final EquipmentProfile profile:
        return _IEquipmentProfileBlocProvider<EquipmentProfile, EquipmentProfileEditBloc>(
          create: (_) => EquipmentProfileEditBloc(
            EquipmentProfilesProvider.of(context),
            profile: profile,
            isEdit: _isEdit,
          ),
          isEdit: _isEdit,
        );
      case final PinholeEquipmentProfile profile:
        return _IEquipmentProfileBlocProvider<PinholeEquipmentProfile, PinholeEquipmentProfileEditBloc>(
          create: (_) => PinholeEquipmentProfileEditBloc(
            EquipmentProfilesProvider.of(context),
            profile: profile,
            isEdit: _isEdit,
          ),
          isEdit: _isEdit,
        );
    }
  }
}

class _IEquipmentProfileBlocProvider<T extends IEquipmentProfile, V extends IEquipmentProfileEditBloc<T>>
    extends StatelessWidget {
  final V Function(BuildContext context) create;
  final bool isEdit;

  const _IEquipmentProfileBlocProvider({
    required this.create,
    required this.isEdit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<IEquipmentProfileEditBloc<T>>(
      create: create,
      child: Builder(
        builder: (context) => BlocProvider<V>.value(
          value: context.read<IEquipmentProfileEditBloc<T>>() as V,
          child: EquipmentProfileEditScreen<T>(isEdit: isEdit),
        ),
      ),
    );
  }
}
