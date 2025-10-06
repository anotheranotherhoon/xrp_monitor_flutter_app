import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xrp_monitor/core/models/common/response_model.dart';
import 'package:xrp_monitor/core/models/common/version_model.dart';
import 'package:xrp_monitor/initApp.dart';
import 'package:xrp_monitor/main.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';
import 'package:xrp_monitor/widgets/dialog/vertical_two_button_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionError extends ConsumerStatefulWidget {
  const VersionError({super.key, required this.type});

  final int type;

  @override
  ConsumerState<VersionError> createState() => _VersionErrorState();
}

class _VersionErrorState extends ConsumerState<VersionError> with WidgetsBindingObserver {
  String appleStoreUrl = '';
  String playStoreUrl = '';
  late int type;
  bool isLoader = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setState(() {
      type = widget.type;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        checkVersion();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  checkVersion() async {
    ResponseModel<VersionModel> checkVersionResult = await InitApp.checkVersion();
    if (checkVersionResult.result!.appStatus == 1) {
      runApp(const ProviderScope(child: MyApp()));
    } else {
      setState(() {
        type = checkVersionResult.result!.appStatus;
      });
    }
  }

  void openStore() {
    String url = '';
    if (Platform.isIOS) {
      url = appleStoreUrl;
    } else {
      url = playStoreUrl;
    }
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: CommonColors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (type == 2)
              VerticalTwoButtonDialog(
                title: '업데이트 안내',
                content: Text(
                  '최신버전의 앱이 존재합니다.\n업데이트를 진행하시겠습니까?',
                  style: TextStyle(fontSize: 20.w, fontWeight: FontWeight.w400, color: CommonColors.mainBlack),
                  textAlign: TextAlign.center,
                ),
                onConfirm: () => openStore(),
                confirmText: '확인',
                onCancel: () {
                  runApp(const ProviderScope(child: MyApp()));
                },
              ),
            if (type == 3)
              VerticalTwoButtonDialog(
                title: '시스템 점검',
                content: Text(
                  '보다 안정적인 서비스를 위한 시스템 점검중입니다.\n일시적으로 모든 서비스 이용이 제한되오니 양해 부탁드립니다.',
                  style: TextStyle(fontSize: 20.w, fontWeight: FontWeight.w400, color: CommonColors.mainBlack),
                  textAlign: TextAlign.center,
                ),
                confirmText: '확인',
                onConfirm:
                    () => {
                  if (Platform.isIOS) {exit(0)} else {SystemNavigator.pop()},
                },
                onCancel: () {},
              ),
            if (!(type == 2 || type == 3 || type == 4))
              VerticalTwoButtonDialog(
                title: '시스템 점검',
                content: Text(
                  '보다 안정적인 서비스를 위한 시스템 점검중입니다.\n일시적으로 모든 서비스 이용이 제한되오니 양해 부탁드립니다.',
                  style: TextStyle(fontSize: 20.w, fontWeight: FontWeight.w400, color: CommonColors.mainBlack),
                  textAlign: TextAlign.center,
                ),
                confirmText: '확인',
                onConfirm:
                    () => {
                  if (Platform.isIOS) {exit(0)} else {SystemNavigator.pop()},
                },
                onCancel: () {},
              ),
          ],
        ),
      ),
    );
  }
}
