import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:xrp_monitor/constants/enums.dart';
import 'package:xrp_monitor/service/storage/local_storage_service.dart';

class PopupVisibilityService {
  PopupVisibilityService._();

  static bool _closedForSession = false;

  static bool get shouldShow {
    if (_closedForSession) return false;
    final hiddenDate = LocalStorageService.instance.getKeyName(
      StorageKey.popupHiddenDate.name,
    );
    return hiddenDate != _today();
  }

  static void closeForSession() {
    _closedForSession = true;
  }

  static Future<void> hideToday() async {
    _closedForSession = true;
    await LocalStorageService.instance.setKeyName(
      StorageKey.popupHiddenDate.name,
      _today(),
    );
  }

  @visibleForTesting
  static void resetSession() {
    _closedForSession = false;
  }

  static String _today() => DateFormat('yyyy-MM-dd').format(DateTime.now());
}
