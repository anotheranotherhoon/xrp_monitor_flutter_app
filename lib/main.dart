import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xrp_monitor/core/services/check_version/check_version.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xrp_monitor/service/storage/local_storage_service.dart';
import 'package:xrp_monitor/ui/themes/default_theme.dart';
import 'package:xrp_monitor/ui/utils/size_unit.dart';
import 'core/common/version_error.dart';
import 'core/models/common/check_version_model.dart';
import 'core/route/app_router.dart';
import 'core/services/base/api_constants.dart';


void main() async{
  ApiConstants.setCheckVersionApi();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await LocalStorageService.instance.init();
  // final CheckVersionModel? checkVersionData = await CheckVersionService().runCheckVersion();
  // Widget app;
  //
  // if (checkVersionData != null && checkVersionData.type == 1) {
  //   String checkDomain = ApiConstants.apiDomain;
  //   if (checkDomain != checkVersionData.apiDomain) {
  //     ApiConstants.setIsDev(checkVersionData.apiDomain);
  //     ApiConstants.setIsDomain(checkVersionData.apiDomain);
  //   }
  //
  // } else {
  //   int type = -1;
  //
  //   if (checkVersionData != null) {
  //     type = checkVersionData.type;
  //   }
  //   app = VersionError(type: type);
  // }

  runApp(ProviderScope(child: ScreenUtilInit(builder: (context, _) => const MyApp())));
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

