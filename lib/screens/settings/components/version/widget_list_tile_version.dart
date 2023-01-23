import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionListTile extends StatelessWidget {
  const VersionListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline),
      title: Text(S.of(context).version),
      trailing: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Text(S.of(context).versionNumber(snapshot.data!.version, snapshot.data!.buildNumber));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
