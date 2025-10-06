part of 'login_screen.dart';

class LoginScreenController extends ConsumerWidgetController<LoginScreen> {
  LoginScreenController ({
    required super.ref
  });

  @override
  void build(BuildContext context) {

  }

  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
    required ValueNotifier<bool> isLoading,
  }) async {
    isLoading.value = true;
    
    try {
      final request = LoginRequest(
        email: email,
        password: password,
      );
      
      final result = await ref.read(authenticationProvider.notifier).login(request);
      
      if (result.success) {
        Fluttertoast.showToast(
          msg: AppStrings.loginSuccess,
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
          msg: AppStrings.loginFailure,
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
