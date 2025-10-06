part of 'signup_screen.dart';

class SignupScreenController extends ConsumerWidgetController<SignupScreen> {
  SignupScreenController ({
    required super.ref
  });

  @override
  void build(BuildContext context) {

  }

  Future<void> signUp({
    required BuildContext context,
    required String email,
    required String nickname,
    required String password,
    required ValueNotifier<bool> isLoading,
  }) async {
    isLoading.value = true;
    
    try {
      final request = SignUpRequest(
        email: email,
        nickname: nickname,
        password: password,
      );
      
      final ResponseModel<bool> result = await ref.read(authenticationProvider.notifier).signUp(request);
      
      if (result.success) {
        Fluttertoast.showToast(
          msg: AppStrings.signupSuccess,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
        );
        
        if (context.mounted) {
          context.router.replaceAll([const TabsRootRoute()]);
        }
      } else {
        Fluttertoast.showToast(
          msg: AppStrings.signupFailure,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: AppStrings.errorWithDetails(e.toString()),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
