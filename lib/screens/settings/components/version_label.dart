import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionLabel extends StatelessWidget {
  const VersionLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          final version = snapshot.data!.version;
          final buildNumber = snapshot.data!.buildNumber;
          return Center(
            child: Text(
              S.of(context).version(version, buildNumber),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
