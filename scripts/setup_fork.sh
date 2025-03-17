constants="const String contactEmail = '';
const String iapServerUrl = '';
const String issuesReportUrl = 'https://github.com/vodemn/m3_lightmeter/issues/new/choose';
const String sourceCodeUrl = 'https://github.com/vodemn/m3_lightmeter/';"

firebase_options="// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform =>
      FirebaseOptions(apiKey: '', appId: '', messagingSenderId: '', projectId: '');
}"

echo "$constants" > "lib/constants.dart"
echo "$firebase_options" > "lib/firebase_options.dart"
sh .github/scripts/stub_iap.sh
