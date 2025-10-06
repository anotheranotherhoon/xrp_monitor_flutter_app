import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
import 'package:xrp_monitor/constants/strings.dart';
import 'package:xrp_monitor/widgets/base/widget_controller.dart';

part 'login_screen.controller.dart';

@RoutePage()
class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LoginScreenController controller = useWidgetController(() => LoginScreenController(ref: ref), context);
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
                const AuthHeader(subtitle: AppStrings.loginSubtitle),
                SizedBox(height: 20.w),

                // Email Field
                AuthTextField(
                  controller: emailController,
                  labelText: AppStrings.email,
                  hintText: AppStrings.emailPlaceholder,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.emailValidator,
                ),

                SizedBox(height: 16.w),

                // Password Field
                AuthTextField(
                  controller: passwordController,
                  labelText: AppStrings.password,
                  hintText: AppStrings.passwordPlaceholder,
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
                  text: AppStrings.login,
                  isLoading: isLoading.value,
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      await controller.login(
                        context: context,
                        email: emailController.text,
                        password: passwordController.text,
                        isLoading: isLoading,
                      );
                    }
                  },
                ),

                SizedBox(height: 24.w),

                // Divider


                SizedBox(height: 24.w),

                // Sign Up Link
                AuthLink(
                  questionText: AppStrings.noAccountQuestion,
                  linkText: AppStrings.signup,
                  onTap: () {
                    context.router.push(const SignupRoute());
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