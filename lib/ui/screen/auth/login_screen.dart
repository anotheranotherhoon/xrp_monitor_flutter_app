import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:auto_route/auto_route.dart';
import 'package:xrp_monitor/constants/app_bar_title.dart';
import 'package:xrp_monitor/core/route/app_router.gr.dart';
import 'package:xrp_monitor/service/authentication/authentication.dart';
import 'package:xrp_monitor/service/authentication/models/login_request.dart';
import 'package:xrp_monitor/widgets/appbar/default_app_bar.dart';
import 'package:xrp_monitor/widgets/auth/auth_header.dart';
import 'package:xrp_monitor/widgets/auth/auth_text_field.dart';
import 'package:xrp_monitor/widgets/auth/auth_button.dart';
import 'package:xrp_monitor/widgets/auth/auth_link.dart';
import 'package:xrp_monitor/utils/validators.dart';

@RoutePage()
class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoading = useState<bool>(false);
    final isPasswordVisible = useState<bool>(false);

    return Scaffold(
      appBar: DefaultAppBar(title: AppBarTitle.signIn),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                SizedBox(height: 20.w),
                const AuthHeader(subtitle: '계정에 로그인하세요'),
                SizedBox(height: 20.w),

                // Email Field
                AuthTextField(
                  controller: emailController,
                  labelText: '이메일',
                  hintText: 'example@email.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.emailValidator,
                ),

                SizedBox(height: 16.w),

                // Password Field
                AuthTextField(
                  controller: passwordController,
                  labelText: '비밀번호',
                  hintText: '비밀번호를 입력하세요',
                  prefixIcon: Icons.lock_outline,
                  obscureText: !isPasswordVisible.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      isPasswordVisible.value = !isPasswordVisible.value;
                    },
                  ),
                  validator: Validators.simplePasswordValidator,
                ),

                SizedBox(height: 20.w),

                SizedBox(height: 16.w),

                // 로그인 버튼
                AuthButton(
                  text: '로그인',
                  isLoading: isLoading.value,
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      isLoading.value = true;
                      try {
                        final request = LoginRequest(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        final result = await ref.read(authenticationProvider.notifier).login(request);
                        if (result.success) {
                          Fluttertoast.showToast(
                            msg: '로그인 성공!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                          if (context.mounted) {
                            context.router.replaceAll([const TabsRootRoute()]);
                          }
                        } else {
                          Fluttertoast.showToast(
                            msg: '로그인에 실패했습니다',
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
                ),

                SizedBox(height: 24.w),

                // Divider


                SizedBox(height: 24.w),

                // Sign Up Link
                AuthLink(
                  questionText: '계정이 없으신가요?',
                  linkText: '회원가입',
                  onTap: () {
                    context.router.push(const SignUpRoute());
                  },
                ),
                ],
              ),
            ),
        ),
      ),
    );
  }
}