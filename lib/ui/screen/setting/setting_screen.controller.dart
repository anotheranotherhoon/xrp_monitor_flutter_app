part of 'setting_screen.dart';


class SettingScreenController extends ConsumerWidgetController<SettingScreen> {
  SettingScreenController({required super.ref});


  final _lock = SyncLock();

  @override
  void build(BuildContext context) {

    super.build(context);
  }


  void logOut(){
    showDialog(
        context: context,
        builder: (context){
          return VerticalTwoButtonDialog(
            title: '안내',
            content: Text(
              '로그아웃 하시겠습니까?',
              style: TextStyle(
                  fontSize: 20.w, fontWeight: FontWeight.w700, color: CommonColors.mainBlack),
              textAlign: TextAlign.center,
            ),
            onConfirm: (){
              ref.read(authenticationProvider.notifier).removeSession();
              context.router.replaceAll([const LoginRoute()]);
            },
            confirmText: '확인',
            onCancel: () {
              context.pop();
            },
          );
        }
    );
  }

  void editPortfolio({
    required String quantity,
    required String averagePrice,
    String? memo,
  }) async{

    // 1️⃣ 키보드 내리기
    FocusScope.of(context).unfocus();

    await _lock.protect(() async {
      try {
        await ref.read(portfolioViewModelProvider.notifier).editPortfolio(
            quantity: quantity,
            averagePrice: averagePrice,
            memo: memo
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('수정 완료되었습니다!'),
              backgroundColor: CommonColors.subBlue,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('수정에 실패했습니다: $e'),
              backgroundColor: CommonColors.mainRed,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }


}
