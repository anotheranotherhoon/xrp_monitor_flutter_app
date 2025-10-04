import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xrp_monitor/core/route/app_router.gr.dart';
import 'package:xrp_monitor/service/authentication/authentication.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';
import 'package:xrp_monitor/ui/utils/sync_lock.dart';
import 'package:xrp_monitor/widgets/appbar/default_app_bar.dart';
import 'package:xrp_monitor/widgets/appbar/default_bottom_bar.dart';
import 'package:xrp_monitor/widgets/base/widget_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xrp_monitor/widgets/dialog/vertical_two_button_dialog.dart';

part 'profile_screen.controller.dart';

@RoutePage()
class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProfileScreenController controller = useWidgetController(() => ProfileScreenController(ref: ref), context);
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final quantityController = useTextEditingController();
    final averagePriceController = useTextEditingController();
    final memoController = useTextEditingController();

    // Custom validators
    String? quantityValidator(String? value) {
      if (value == null || value.isEmpty) {
        return '보유 수량을 입력해주세요';
      }
      if (int.parse(value) < 0) {
        return '음수는 입력할 수 없습니다.';
      }
      return null;
    }

    String? averagePriceValidator(String? value) {
      if (value == null || value.isEmpty) {
        return '평균 매수가를 입력해주세요';
      }
      if (int.parse(value) < 0) {
        return '음수는 입력할 수 없습니다.';
      }
      return null;
    }


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: DefaultAppBar(title: 'PROFILE'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 8.h),
              // Email Field
              TextFormField(
                controller: quantityController,
                decoration: InputDecoration(
                  labelText: 'XRP 보유 수량',
                  hintText: '0',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: quantityValidator,
              ),

              SizedBox(height: 16.h),

              // Nickname Field
              TextFormField(
                controller: averagePriceController,
                decoration: InputDecoration(
                  labelText: '평균 매수가',
                  hintText: '평균 매수가를 입력하세요.',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                validator: averagePriceValidator,
              ),

              SizedBox(height: 16.h),

              // Password Field
              TextFormField(
                controller: memoController,
                decoration: InputDecoration(
                  labelText: '메모',
                  hintText: '메모를 입력하세요.',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.h),


              SizedBox(height: 24.h),

              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.router.pop();
                    },
                    child: Text(
                      '포트폴리오 수정',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      controller.logOut();
                    },
                    child: Text(
                      '로그아웃',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      );
  }
}


