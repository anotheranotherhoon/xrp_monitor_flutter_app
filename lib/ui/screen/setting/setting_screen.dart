import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xrp_monitor/constants/app_bar_title.dart';
import 'package:xrp_monitor/core/route/app_router.gr.dart';
import 'package:xrp_monitor/service/authentication/authentication.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';
import 'package:xrp_monitor/ui/screen/setting/view_models/portfolio_view_model.dart';
import 'package:xrp_monitor/ui/screen/setting/widget/portfolio_card.dart';
import 'package:xrp_monitor/ui/utils/sync_lock.dart';
import 'package:xrp_monitor/utils/validators.dart';
import 'package:xrp_monitor/widgets/appbar/default_app_bar.dart';
import 'package:xrp_monitor/widgets/base/widget_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xrp_monitor/widgets/dialog/vertical_two_button_dialog.dart';
import 'package:xrp_monitor/widgets/button/action_button.dart';

part 'setting_screen.controller.dart';

@RoutePage()
class SettingScreen extends HookConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useWidgetController(() => SettingScreenController(ref: ref), context);
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final quantityController = useTextEditingController();
    final averagePriceController = useTextEditingController();
    final memoController = useTextEditingController();

    // Portfolio 상태 감시 및 초기값 설정
    final portfolioAsyncValue = ref.watch(portfolioViewModelProvider);
    
    useEffect(() {
      portfolioAsyncValue.whenData((portfolioState) {
        final portfolio = portfolioState.portfolio;
        if (portfolio != null) {
          quantityController.text = portfolio.quantity;
          averagePriceController.text = portfolio.averagePrice;
          memoController.text = portfolio.memo;
        }
      });
      return null;
    }, [portfolioAsyncValue]);



    return Scaffold(
      backgroundColor: CommonColors.grey300,
      appBar: DefaultAppBar(title: AppBarTitle.profile),
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            },
        behavior: HitTestBehavior.translucent,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0.w),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                PortfolioCard(
                  quantityController:quantityController,
                  averagePriceController:averagePriceController,
                  memoController:memoController,
                  quantityValidator:Validators.quantityValidator,
                  averagePriceValidator:Validators.averagePriceValidator,
                ),
                SizedBox(height: 24.0.w),
                ActionButton.edit(
                  onTap: () {
                    controller.editPortfolio(
                      quantity: quantityController.text,
                      averagePrice: averagePriceController.text,
                      memo: memoController.text,
                    );
                  },
                ),
                SizedBox(height: 24.0.w),
                ActionButton.logout(
                  onTap: () {
                    controller.logOut();
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
