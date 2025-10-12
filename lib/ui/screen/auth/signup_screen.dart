import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:auto_route/auto_route.dart';
import 'package:xrp_monitor/constants/app_bar_title.dart';
import 'package:xrp_monitor/core/services/base/models/response_model.dart';
import 'package:xrp_monitor/core/route/app_router.gr.dart';
import 'package:xrp_monitor/service/authentication/authentication.dart';
import 'package:xrp_monitor/service/authentication/models/signup_request.dart';
import 'package:xrp_monitor/widgets/appbar/default_app_bar.dart';
import 'package:xrp_monitor/widgets/auth/auth_header.dart';
import 'package:xrp_monitor/widgets/auth/auth_text_field.dart';
import 'package:xrp_monitor/widgets/auth/auth_button.dart';
import 'package:xrp_monitor/widgets/auth/auth_link.dart';
import 'package:xrp_monitor/utils/validators.dart';
import 'package:xrp_monitor/constants/strings.dart';
import 'package:xrp_monitor/widgets/base/widget_controller.dart';

part 'signup_screen.controller.dart';

@RoutePage()
class SignupScreen extends HookConsumerWidget {


  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SignupScreenController controller = useWidgetController(() => SignupScreenController(ref: ref), context);
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
                const AuthHeader(subtitle: AppStrings.signupSubtitle),
                SizedBox(height: 40.w),

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

                // Nickname Field
                AuthTextField(
                  controller: nicknameController,
                  labelText: AppStrings.nickname,
                  hintText: AppStrings.nicknamePlaceholder,
                  prefixIcon: Icons.person_outline,
                  validator: Validators.nicknameValidator,
                ),

                SizedBox(height: 16.w),

                // Password Field
                AuthTextField(
                  controller: passwordController,
                  labelText: AppStrings.password,
                  hintText: AppStrings.passwordPlaceholder,
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  validator: Validators.passwordValidator,
                ),

                SizedBox(height: 16.w),

                // Confirm Password Field
                AuthTextField(
                  controller: confirmPasswordController,
                  labelText: AppStrings.passwordConfirm,
                  hintText: AppStrings.passwordConfirmPlaceholder,
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  validator: (value) => Validators.confirmPasswordValidator(value, passwordController.text),
                ),

                SizedBox(height: 16.w),

                AuthButton(
                  text: AppStrings.signup,
                  isLoading: isLoading.value,
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      await controller.signUp(
                        context: context,
                        email: emailController.text,
                        nickname: nicknameController.text,
                        password: passwordController.text,
                        isLoading: isLoading,
                      );
                    }
                  },
                ),

                SizedBox(height: 24.w),

                // Login Link
                AuthLink(
                  questionText: AppStrings.hasAccountQuestion,
                  linkText: AppStrings.login,
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