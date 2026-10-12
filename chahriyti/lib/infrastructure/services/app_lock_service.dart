import 'package:local_auth/local_auth.dart';
import '../../core/storage/app_secure_storage.dart';

/// App lock with the phone's own security (Face ID / fingerprint, falling
/// back to the phone PIN or pattern). No app-specific PIN: the app is offline,
/// so a forgotten PIN could never be recovered.
class AppLockService {
  final _auth = LocalAuthentication();
  final _storage = appSecureStorage;

  static const _enabledKey = 'chahriyti_lock_enabled';
  static const _delayKey = 'chahriyti_lock_delay_seconds';
  static const _hideAmountsKey = 'chahriyti_lock_hide_amounts';

  /// Lock delay choices, in seconds.
  static const delays = [0, 60, 300];
  static const defaultDelay = 60;

  /// True while the system prompt is up; the app goes to the background
  /// then, which must not count as leaving the app.
  bool isAuthenticating = false;

  Future<bool> isEnabled() async =>
      (await _storage.read(key: _enabledKey)) == 'true';

  Future<int> delaySeconds() async =>
      int.tryParse(await _storage.read(key: _delayKey) ?? '') ?? defaultDelay;

  /// Hide amounts in notifications; only applies while the lock is on.
  Future<bool> hideAmounts() async =>
      (await _storage.read(key: _hideAmountsKey)) != 'false';

  Future<bool> shouldHideAmounts() async =>
      await isEnabled() && await hideAmounts();

  /// Whether the phone has any screen lock to rely on.
  Future<bool> isDeviceSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  /// Shows the system prompt. Returns false on cancel or failure.
  Future<bool> authenticate(String reason) async {
    if (isAuthenticating) return false;
    isAuthenticating = true;
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        persistAcrossBackgrounding: true,
      );
    } catch (_) {
      return false;
    } finally {
      isAuthenticating = false;
    }
  }

  Future<void> setEnabled(bool enabled) =>
      _storage.write(key: _enabledKey, value: '$enabled');

  Future<void> setDelaySeconds(int seconds) =>
      _storage.write(key: _delayKey, value: '$seconds');

  Future<void> setHideAmounts(bool hide) =>
      _storage.write(key: _hideAmountsKey, value: '$hide');
}
