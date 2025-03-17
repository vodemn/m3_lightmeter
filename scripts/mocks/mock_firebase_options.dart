// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform =>
      FirebaseOptions(apiKey: '', appId: '', messagingSenderId: '', projectId: '');
}
