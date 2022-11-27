import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/permissions_service.dart';
import 'package:lightmeter/screens/permissions_check/screen_permissions_check.dart';

import 'bloc_permissions_check.dart';

class PermissionsCheckFlow extends StatelessWidget {
  const PermissionsCheckFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PermissionsCheckBloc(context.read<PermissionsService>()),
      child: const PermissionsCheckScreen(),
    );
  }
}
