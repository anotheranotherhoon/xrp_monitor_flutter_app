import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xrp_monitor/core/route/app_router.gr.dart';
import 'package:xrp_monitor/service/authentication/authentication.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';
import 'package:xrp_monitor/ui/utils/sync_lock.dart';
import 'package:xrp_monitor/widgets/base/widget_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xrp_monitor/widgets/dialog/vertical_two_button_dialog.dart';
import 'package:xrp_monitor/ui/screen/profile/view_models/portfolio_view_model.dart';
import 'package:xrp_monitor/ui/screen/profile/models/portfolio_model.dart';

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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              _buildPortfolioCard(
                quantityController,
                averagePriceController,
                memoController,
                quantityValidator,
                averagePriceValidator,
              ),
              SizedBox(height: 40.h),
              _buildEditButton(
                controller,
                quantityController,
                averagePriceController,
                memoController,
              ),
              SizedBox(height: 40.h),
              _buildLogoutButton(controller),
            ],
          ),
        ),
      ),
    );
  }

  // 포트폴리오 카드
  Widget _buildPortfolioCard(
      TextEditingController quantityController,
      TextEditingController averagePriceController,
      TextEditingController memoController,
      String? Function(String?) quantityValidator,
      String? Function(String?) averagePriceValidator,
      ) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'XRP Portfolio',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          SizedBox(height: 32.h),

          // XRP 보유량
          _buildInputField(
            label: 'XRP Holdings',
            controller: quantityController,
            hint: '0.00',
            validator: quantityValidator,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            suffix: 'XRP',
          ),
          SizedBox(height: 20.h),

          // 평균 매수가
          _buildInputField(
            label: 'Average Price',
            controller: averagePriceController,
            hint: '0.00',
            validator: averagePriceValidator,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            suffix: 'USD',
          ),
          SizedBox(height: 20.h),

          // 메모
          _buildInputField(
            label: 'Notes',
            controller: memoController,
            hint: 'Investment notes...',
            maxLines: 3,
          ),
          SizedBox(height: 32.h),

          // 저장 버튼
          Container(
            width: double.infinity,
            height: 48.h,
            margin: EdgeInsets.symmetric(vertical: 8.h),
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                print('Save Changes 버튼 클릭됨!');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B9687),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 2,
                shadowColor: Colors.black.withValues(alpha: 0.1),
              ),
              child: Text(
                'Save Changes',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 입력 필드
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    String? suffix,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4A5568),
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          inputFormatters: keyboardType == const TextInputType.numberWithOptions(decimal: true)
              ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
              : null,
          style: TextStyle(
            fontSize: 16.sp,
            color: const Color(0xFF2D3748),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: const Color(0xFFA0AEC0),
              fontSize: 16.sp,
            ),
            suffixText: suffix,
            suffixStyle: TextStyle(
              color: const Color(0xFF718096),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: const Color(0xFFF7FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Color(0xFF0B9687),
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
        ),
      ],
    );
  }

  // 로그아웃 버튼
  Widget _buildLogoutButton(ProfileScreenController controller) {
    return Container(
      width: double.infinity,
      height: 60, // ScreenUtil 없이도 보이도록 고정
      margin: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.red.shade100, // 더 눈에 띄는 배경
        border: Border.all(color: Colors.red.shade700, width: 2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          print('로그아웃 버튼 클릭됨!');
          HapticFeedback.lightImpact();
          controller.logOut();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            FaIcon(FontAwesomeIcons.rightFromBracket, color: Colors.red, size: 26),
            SizedBox(width: 12),
            Text(
              'Logout',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditButton(
    ProfileScreenController controller,
    TextEditingController quantityController,
    TextEditingController averagePriceController,
    TextEditingController memoController,
  ) {
    return Container(
      width: double.infinity,
      height: 60, // ScreenUtil 없이도 보이도록 고정
      margin: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.blue.shade100, // 더 눈에 띄는 배경
        border: Border.all(color: Colors.blue.shade700, width: 2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          HapticFeedback.lightImpact();
          controller.editPortfolio(
            quantity: quantityController.text,
            averagePrice: averagePriceController.text,
            memo: memoController.text,
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            FaIcon(FontAwesomeIcons.penToSquare, color: Colors.blue, size: 26),
            SizedBox(width: 12),
            Text(
              '포트폴리오 수정',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }


}
