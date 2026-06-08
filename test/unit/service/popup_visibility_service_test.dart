import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xrp_monitor/constants/enums.dart';
import 'package:xrp_monitor/service/popup/popup_visibility_service.dart';
import 'package:xrp_monitor/service/storage/local_storage_service.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorageService.instance.init();
  });

  setUp(() async {
    await LocalStorageService.instance.removeKeyName(
      StorageKey.popupHiddenDate.name,
    );
    PopupVisibilityService.resetSession();
  });

  test('close hides all popups for the current app session', () {
    expect(PopupVisibilityService.shouldShow, isTrue);

    PopupVisibilityService.closeForSession();

    expect(PopupVisibilityService.shouldShow, isFalse);
  });

  test(
    'hide today stores one global date for the entire popup carousel',
    () async {
      await PopupVisibilityService.hideToday();
      PopupVisibilityService.resetSession();

      expect(
        LocalStorageService.instance.getKeyName(
          StorageKey.popupHiddenDate.name,
        ),
        DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );
      expect(PopupVisibilityService.shouldShow, isFalse);
    },
  );
}
