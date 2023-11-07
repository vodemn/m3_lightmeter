import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:lightmeter/data/models/feature.dart';

class RemoteConfigService {
  const RemoteConfigService();

  Future<void> activeAndFetchFeatures() async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    const cacheStaleDuration = kDebugMode ? Duration(minutes: 1) : Duration(hours: 12);

    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 15),
          minimumFetchInterval: cacheStaleDuration,
        ),
      );
      await remoteConfig.setDefaults(featuresDefaultValues.map((key, value) => MapEntry(key.name, value)));
      await remoteConfig.activate();
      await remoteConfig.ensureInitialized();

      log('Firebase remote config initialized successfully');
    } on FirebaseException catch (e) {
      _logError('Firebase exception during Firebase Remote Config initialization: $e');
    } on Exception catch (e) {
      _logError('Error during Firebase Remote Config initialization: $e');
    }
  }

  Future<void> fetchConfig() => FirebaseRemoteConfig.instance.fetch();

  dynamic getValue(Feature feature) => FirebaseRemoteConfig.instance.getValue(feature.name).toValue(feature);

  Map<Feature, dynamic> getAll() {
    final Map<Feature, dynamic> result = {};
    for (final value in FirebaseRemoteConfig.instance.getAll().entries) {
      try {
        final feature = Feature.values.firstWhere((f) => f.name == value.key);
        result[feature] = value.value.toValue(feature);
      } catch (e) {
        log(e.toString());
      }
    }
    return result;
  }

  Stream<Set<Feature>> onConfigUpdated() => FirebaseRemoteConfig.instance.onConfigUpdated.asyncMap(
        (event) async {
          await FirebaseRemoteConfig.instance.activate();
          final Set<Feature> updatedFeatures = {};
          for (final key in event.updatedKeys) {
            try {
              updatedFeatures.add(Feature.values.firstWhere((element) => element.name == key));
            } catch (e) {
              log(e.toString());
            }
          }
          return updatedFeatures;
        },
      );

  bool isEnabled(Feature feature) => FirebaseRemoteConfig.instance.getBool(feature.name);

  void _logError(dynamic throwable, {StackTrace? stackTrace}) {
    FirebaseCrashlytics.instance.recordError(throwable, stackTrace);
  }
}

extension on RemoteConfigValue {
  dynamic toValue(Feature feature) {
    switch (feature) {
      case Feature.unlockProFeaturesText:
        return asBool();
    }
  }
}
