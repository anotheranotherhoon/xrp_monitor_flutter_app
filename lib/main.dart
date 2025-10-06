import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xrp_monitor/core/models/common/response_model.dart';
import 'package:xrp_monitor/core/models/common/version_model.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xrp_monitor/initApp.dart';
import 'package:xrp_monitor/service/storage/local_storage_service.dart';
import 'package:xrp_monitor/service/native_service.dart';
import 'package:xrp_monitor/ui/themes/default_theme.dart';
import 'package:xrp_monitor/ui/utils/size_unit.dart';
import 'core/common/version_error.dart';
import 'core/route/app_router.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await LocalStorageService.instance.init();
  Widget app;
  ResponseModel<VersionModel> checkVersionResult = await InitApp.checkVersion();
  if(checkVersionResult.result!.appStatus != 1){
    // appStatus가 1이 아닐 때 네이티브 알림 및 진동 실행
    await NativeService.showUpdateNotification(
      appStatus: checkVersionResult.result!.appStatus,
      downloadUrl: checkVersionResult.result!.downloadUrl,
      releaseNotes: checkVersionResult.result!.releaseNotes,
    );
    app = VersionError(type: checkVersionResult.result!.appStatus );
  }else{
    app = const MyApp();
  }

  runApp(ProviderScope(child: ScreenUtilInit(builder: (context, _) => app)));
}




class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CommonSize.setSizes(context);

    });

  }
  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    return KeyboardVisibilityProvider(
      child: ScreenUtilInit(
        designSize: Size.fromWidth(360),
        builder: (context, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'XRP Monitor',
            routerConfig: router.config(),
            theme: defaultTheme,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                child: Stack(
                  children: [
                  child!,
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

