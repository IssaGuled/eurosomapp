import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigManager {
  static final RemoteConfigManager _singleton = RemoteConfigManager._internal();

  factory RemoteConfigManager() {
    return _singleton;
  }

  RemoteConfigManager._internal();

  final _remoteConfig = FirebaseRemoteConfig.instance;
  static const _key_is_test_env_enabled = "is_test_env_enabled";
  static const _key_whatsapp_number = "whatsapp_number";
  static const _key_dial_number = "dial_number";

  init() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(minutes: 1),
    ));
    _remoteConfig.setDefaults({
      _key_is_test_env_enabled: false,
      _key_whatsapp_number: "+252619255803",
      _key_dial_number: "+252619255803",
    });
    _remoteConfig.fetchAndActivate();
  }

  bool get isTestEnvEnabled => _remoteConfig.getBool(_key_is_test_env_enabled);

  String get whatsAppNumber => _remoteConfig.getString(_key_whatsapp_number);

  String get dialNumber => _remoteConfig.getString(_key_dial_number);
}
