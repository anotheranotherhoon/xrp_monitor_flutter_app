part of 'profile_screen.dart';


class ProfileScreenController extends ConsumerWidgetController<ProfileScreen> {
  ProfileScreenController({required super.ref});


  final _lock = SyncLock();

  @override
  void build(BuildContext context) {

    super.build(context);
  }

  void logOut(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return VerticalTwoButtonDialog(
            title: '안내',
            content: Text(
              '로그아웃 하시겠습니까?',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400, color: CommonColors.mainGreen),
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

}


