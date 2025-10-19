part of 'login_screen.dart';

class LoginScreenController extends ConsumerWidgetController<LoginScreen> {
  LoginScreenController ({
    required super.ref
  });

  @override
  void build(BuildContext context) {

  }

  /// 키보드 높이를 고려한 토스트 위치 결정
  ToastGravity _getToastGravity(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).viewInsets.bottom;
    // 키보드가 올라와 있으면 (높이 100 이상) CENTER로, 아니면 BOTTOM으로
    return bottomInset > 100 ? ToastGravity.CENTER : ToastGravity.BOTTOM;
  }

  /// 키보드 상태를 고려한 안전한 토스트 표시
  void _showSafeToast(BuildContext context, String message, {bool isSuccess = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: _getToastGravity(context),
      backgroundColor: isSuccess ? Colors.green.shade700 : Colors.red.shade700,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
    required ValueNotifier<bool> isLoading,
  }) async {
    isLoading.value = true;
    
    try {
      final LoginRequest request = LoginRequest(
        email: email,
        password: password,
      );
      
      final ResponseModel<LoginResult> result = await ref.read(authenticationProvider.notifier).login(request);
      
      if (result.success) {
        // 로그인 성공시 토스트 없이 바로 화면 전환 (화면 전환 자체가 성공 피드백)
        if (context.mounted) {
          context.router.replaceAll([const TabsRootRoute()]);
        }
      } else {
        _showSafeToast(context, AppStrings.loginFailure);
      }
    } catch (e) {
      _showSafeToast(context, AppStrings.errorWithDetails(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }
}
