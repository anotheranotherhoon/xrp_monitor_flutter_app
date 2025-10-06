import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:auto_route/auto_route.dart';
import 'package:xrp_monitor/core/route/app_router.gr.dart';
import 'package:xrp_monitor/service/authentication/authentication.dart';
import 'package:xrp_monitor/service/authentication/models/signup_request.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';

@RoutePage()
class SignUpScreen extends HookConsumerWidget {


  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final emailController = useTextEditingController();
    final nicknameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final isLoading = useState<bool>(false);

    // Custom validators
    String? emailValidator(String? value) {
      if (value == null || value.isEmpty) {
        return '이메일을 입력해주세요';
      }
      final emailRegExp = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegExp.hasMatch(value)) {
        return '올바른 이메일 형식을 입력해주세요';
      }
      return null;
    }

    String? nicknameValidator(String? value) {
      if (value == null || value.isEmpty) {
        return '닉네임을 입력해주세요';
      }
      if (value.length < 2) {
        return '닉네임은 2자 이상이어야 합니다';
      }
      if (value.length > 20) {
        return '닉네임은 20자 이하여야 합니다';
      }
      return null;
    }

    String? passwordValidator(String? value) {
      if (value == null || value.isEmpty) {
        return '비밀번호를 입력해주세요';
      }
      if (value.length < 8) {
        return '비밀번호는 8자 이상이어야 합니다';
      }
      final passwordRegExp = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]');
      if (!passwordRegExp.hasMatch(value)) {
        return '영문, 숫자, 특수문자를 포함해야 합니다';
      }
      return null;
    }

    String? confirmPasswordValidator(String? value) {
      if (value == null || value.isEmpty) {
        return '비밀번호 확인을 입력해주세요';
      }
      if (value != passwordController.text) {
        return '비밀번호가 일치하지 않습니다';
      }
      return null;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40.h),
              Text(
                'XRP Monitor',
                style: TextStyle(
                  fontSize: 32.w,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                '새 계정을 만들어보세요',
                style: TextStyle(
                  fontSize: 16.w,
                  color: CommonColors.grey600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),
              
              // Email Field
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: '이메일',
                  hintText: 'example@email.com',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: emailValidator,
              ),
              
              SizedBox(height: 16.h),
              
              // Nickname Field
              TextFormField(
                controller: nicknameController,
                decoration: InputDecoration(
                  labelText: '닉네임',
                  hintText: '사용할 닉네임을 입력하세요',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                validator: nicknameValidator,
              ),
              
              SizedBox(height: 16.h),
              
              // Password Field
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  hintText: '비밀번호를 입력하세요',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                obscureText: true,
                validator: passwordValidator,
              ),
              
              SizedBox(height: 16.h),
              
              // Confirm Password Field
              TextFormField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: '비밀번호 확인',
                  hintText: '비밀번호를 다시 입력하세요',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                obscureText: true,
                validator: confirmPasswordValidator,
              ),
              
              SizedBox(height: 32.h),
              
              // Sign Up Button
              SizedBox(
                height: 56.h,
                child: ElevatedButton(
                  onPressed: isLoading.value ? null : () async {
                    if (formKey.currentState?.validate() ?? false) {
                      isLoading.value = true;
                      final router = context.router;
                      try {
                        final request = SignUpRequest(
                          email: emailController.text,
                          password: passwordController.text,
                          nickname: nicknameController.text,
                        );
                        
                        final result = await ref.read(authenticationProvider.notifier).signUp(request);
                        
                        if (result.success) {
                          Fluttertoast.showToast(
                            msg: '회원가입이 완료되었습니다!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                          router.replaceAll([const TabsRootRoute()]);
                        } else {
                          Fluttertoast.showToast(
                            msg:'회원가입에 실패했습니다',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                        }
                      } catch (e) {
                        Fluttertoast.showToast(
                          msg: '오류가 발생했습니다: $e',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                      } finally {
                        isLoading.value = false;
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: CommonColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: isLoading.value
                      ? SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: CircularProgressIndicator(
                            color: CommonColors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          '회원가입',
                          style: TextStyle(
                            fontSize: 16.w,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              
              SizedBox(height: 24.h),
              
              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '이미 계정이 있으신가요? ',
                    style: TextStyle(
                      fontSize: 14.w,
                      color: CommonColors.grey600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.router.pop();
                    },
                    child: Text(
                      '로그인',
                      style: TextStyle(
                        fontSize: 14.w,
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