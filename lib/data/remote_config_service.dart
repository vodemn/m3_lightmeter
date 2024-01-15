import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:lightmeter/data/models/feature.dart';

abstract class IRemoteConfigService {
  const IRemoteConfigService();

  Future<void> activeAndFetchFeatures();

  Future<void> fetchConfig();

  dynamic getValue(Feature feature);

  Map<Feature, dynamic> getAll();

  Stream<Set<Feature>> onConfigUpdated();

  bool isEnabled(Feature feature);
}

class RemoteConfigService implements IRemoteConfigService {
  const RemoteConfigService();

  @override
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
    } catch (e) {
      _logError('Error during Firebase Remote Config initialization: $e');
    }
  }

  @override
  Future<void> fetchConfig() async {
    try {
      // https://github.com/firebase/flutterfire/issues/6196#issuecomment-927751667
      await Future.delayed(const Duration(seconds: 1));
      await FirebaseRemoteConfig.instance.fetch();
    } on FirebaseException catch (e) {
      _logError('Firebase exception during Firebase Remote Config fetch: $e');
    } catch (e) {
      _logError('Error during Firebase Remote Config fetch: $e');
    }
  }

  @override
  dynamic getValue(Feature feature) => FirebaseRemoteConfig.instance.getValue(feature.name).toValue(feature);

  @override
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

  @override
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

  @override
  bool isEnabled(Feature feature) => FirebaseRemoteConfig.instance.getBool(feature.name);

  void _logError(dynamic throwable, {StackTrace? stackTrace}) {
    FirebaseCrashlytics.instance.recordError(throwable, stackTrace);
  }
}

class MockRemoteConfigService implements IRemoteConfigService {
  const MockRemoteConfigService();

  @override
  Future<void> activeAndFetchFeatures() async {}

  @override
  Future<void> fetchConfig() async {}

  @override
  Map<Feature, dynamic> getAll() => featuresDefaultValues;

  @override
  dynamic getValue(Feature feature) => featuresDefaultValues[feature];

  @override
  // ignore: cast_nullable_to_non_nullable
  bool isEnabled(Feature feature) => featuresDefaultValues[feature] as bool;

  @override
  Stream<Set<Feature>> onConfigUpdated() => const Stream.empty();
}

extension on RemoteConfigValue {
  dynamic toValue(Feature feature) {
    switch (feature) {
      case Feature.showUnlockProOnMainScreen:
        return asBool();
    }
  }
}
