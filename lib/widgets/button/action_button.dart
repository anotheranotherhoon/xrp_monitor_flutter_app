import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color iconColor;
  final VoidCallback onTap;
  final double width;
  final double height;
  final EdgeInsets margin;

  const ActionButton({
    super.key,
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.iconColor,
    required this.onTap,
    this.width = double.infinity,
    this.height = 60,
    this.margin = const EdgeInsets.all(0)
  });

  /// 🔵 포트폴리오 수정 버튼
  factory ActionButton.edit({
    required VoidCallback onTap,
    double width = double.infinity,
    double height = 60,
  }) {
    return ActionButton(
      text: '포트폴리오 수정',
      icon: FontAwesomeIcons.penToSquare,
      backgroundColor: Colors.blue.shade100,
      borderColor: Colors.blue.shade700,
      textColor: Colors.blue.shade800,
      iconColor: Colors.blue.shade800,
      onTap: onTap,
      width: width,
      height: height,
    );
  }

  /// 🔴 로그아웃 버튼
  factory ActionButton.logout({
    required VoidCallback onTap,
    double width = double.infinity,
    double height = 60,
  }) {
    return ActionButton(
      text: 'Logout',
      icon: FontAwesomeIcons.rightFromBracket,
      backgroundColor: Colors.red.shade100,
      borderColor: Colors.red.shade700,
      textColor: Colors.red.shade800,
      iconColor: Colors.red.shade800,
      onTap: onTap,
      width: width,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias, // splash 효과 영역 제한
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(icon, color: iconColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
