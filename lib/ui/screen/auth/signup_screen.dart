import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:auto_route/auto_route.dart';
import 'package:xrp_monitor/constants/app_bar_title.dart';
import 'package:xrp_monitor/core/models/common/response_model.dart';
import 'package:xrp_monitor/core/route/app_router.gr.dart';
import 'package:xrp_monitor/service/authentication/authentication.dart';
import 'package:xrp_monitor/service/authentication/models/signup_request.dart';
import 'package:xrp_monitor/widgets/appbar/default_app_bar.dart';
import 'package:xrp_monitor/widgets/auth/auth_header.dart';
import 'package:xrp_monitor/widgets/auth/auth_text_field.dart';
import 'package:xrp_monitor/widgets/auth/auth_button.dart';
import 'package:xrp_monitor/widgets/auth/auth_link.dart';
import 'package:xrp_monitor/utils/validators.dart';

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

    return Scaffold(
      appBar: DefaultAppBar(title: AppBarTitle.signUp),
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
                SizedBox(height: 40.w),
                const AuthHeader(subtitle: '새 계정을 만들어보세요'),
                SizedBox(height: 40.w),

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

                // Nickname Field
                AuthTextField(
                  controller: nicknameController,
                  labelText: '닉네임',
                  hintText: '사용할 닉네임을 입력하세요',
                  prefixIcon: Icons.person_outline,
                  validator: Validators.nicknameValidator,
                ),

                SizedBox(height: 16.w),

                // Password Field
                AuthTextField(
                  controller: passwordController,
                  labelText: '비밀번호',
                  hintText: '비밀번호를 입력하세요',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  validator: Validators.passwordValidator,
                ),

                SizedBox(height: 16.w),

                // Confirm Password Field
                AuthTextField(
                  controller: confirmPasswordController,
                  labelText: '비밀번호 확인',
                  hintText: '비밀번호를 다시 입력하세요',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  validator: (value) => Validators.confirmPasswordValidator(value, passwordController.text),
                ),

                SizedBox(height: 16.w),

                AuthButton(
                  text: '회원가입',
                  isLoading: isLoading.value,
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      isLoading.value = true;
                      try {
                        final request = SignUpRequest(
                          email: emailController.text,
                          nickname: nicknameController.text,
                          password: passwordController.text,
                        );
                        final ResponseModel<bool> result = await ref.read(authenticationProvider.notifier).signUp(request);
                        if (result.success) {
                          Fluttertoast.showToast(
                            msg: '회원가입 성공!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                          if (context.mounted) {
                            context.router.replaceAll([const TabsRootRoute()]);
                          }
                        } else {
                          Fluttertoast.showToast(
                            msg: '회원가입에 실패했습니다',
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

                // Login Link
                AuthLink(
                  questionText: '이미 계정이 있으신가요?',
                  linkText: '로그인',
                  onTap: () {
                    context.router.pop();
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