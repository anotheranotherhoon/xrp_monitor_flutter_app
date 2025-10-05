import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xrp_monitor/core/route/app_router.gr.dart';
import 'package:xrp_monitor/service/authentication/authentication.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';
import 'package:xrp_monitor/ui/screen/profile/widget/portfolio_card.dart';
import 'package:xrp_monitor/ui/screen/profile/widget/portfolio_input.dart';
import 'package:xrp_monitor/ui/utils/sync_lock.dart';
import 'package:xrp_monitor/widgets/base/widget_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xrp_monitor/widgets/dialog/vertical_two_button_dialog.dart';
import 'package:xrp_monitor/ui/screen/profile/view_models/portfolio_view_model.dart';
import 'package:xrp_monitor/widgets/button/action_button.dart';

part 'profile_screen.controller.dart';

@RoutePage()
class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useWidgetController(() => ProfileScreenController(ref: ref), context);
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final quantityController = useTextEditingController();
    final averagePriceController = useTextEditingController();
    final memoController = useTextEditingController();

    // Portfolio 상태 감시 및 초기값 설정
    final portfolioAsyncValue = ref.watch(portfolioViewModelProvider);
    
    useEffect(() {
      portfolioAsyncValue.whenData((portfolioState) {
        final portfolio = portfolioState.portfolio;
        print('portfolio ${portfolio}');
        if (portfolio != null) {
          quantityController.text = portfolio.quantity;
          averagePriceController.text = portfolio.averagePrice;
          memoController.text = portfolio.memo;
        }
      });
      return null;
    }, [portfolioAsyncValue]);

    // Custom validators
    String? quantityValidator(String? value) {
      if (value == null || value.isEmpty) {
        return '보유 수량을 입력해주세요';
      }
      if (double.tryParse(value) == null || double.parse(value) < 0) {
        return '올바른 수량을 입력해주세요';
      }
      return null;
    }

    String? averagePriceValidator(String? value) {
      if (value == null || value.isEmpty) {
        return '평균 매수가를 입력해주세요';
      }
      if (double.tryParse(value) == null || double.parse(value) < 0) {
        return '올바른 가격을 입력해주세요';
      }
      return null;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'My Portfolio',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF2D3748)),
      ),
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            },
        behavior: HitTestBehavior.translucent,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                PortfolioCard(
                  quantityController:quantityController,
                  averagePriceController:averagePriceController,
                  memoController:memoController,
                  quantityValidator:quantityValidator,
                  averagePriceValidator:averagePriceValidator,
                ),
                ActionButton.edit(
                  onTap: () {
                    controller.editPortfolio(
                      quantity: quantityController.text,
                      averagePrice: averagePriceController.text,
                      memo: memoController.text,
                    );
                  },
                ),
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
