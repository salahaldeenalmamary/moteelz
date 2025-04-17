import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StepProgressIndicator extends StatelessWidget
    implements PreferredSizeWidget {
  final int currentStep;
  final List<String> stepTitles;
  final Color? activeColor;
  final Color? inactiveColor;
  final TextStyle? textStyle;
  final TextStyle? activeTextStyle;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.stepTitles,
    this.activeColor,
    this.inactiveColor,
    this.textStyle,
    this.activeTextStyle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

   @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = activeColor ?? theme.primaryColor;
    final inactive = inactiveColor ?? theme.dividerColor;
    final totalSteps = stepTitles.length;

    return PreferredSize(
      preferredSize: preferredSize,

      child: Column(
        children: [
          Row(
            children: [
              for (int i = 0; i < totalSteps; i++) ...[
                _StepIndicatorItem(
                  title: stepTitles[i],
                  stepNumber: i + 1,
                  isActive: currentStep == i,
                  isCompleted: currentStep > i,
                  activeColor: active,
                  inactiveColor: inactive,
                  textStyle: textStyle,
                  activeTextStyle: activeTextStyle,
                ),
                if (i != totalSteps - 1)
                  Expanded(
                    child: _ProgressBar(
                      progress: currentStep > i ? 1.0 : 0.5,
                      activeColor: active,
                      inactiveColor: inactive,
                    ),
                  ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StepIndicatorItem extends StatelessWidget {
  final String title;
  final int stepNumber;
  final bool isActive;
  final bool isCompleted;
  final Color activeColor;
  final Color inactiveColor;
  final TextStyle? textStyle;
  final TextStyle? activeTextStyle;

  const _StepIndicatorItem({
    required this.title,
    required this.stepNumber,
    required this.isActive,
    required this.isCompleted,
    required this.activeColor,
    required this.inactiveColor,
    this.textStyle,
    this.activeTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isHighlighted = isActive || isCompleted;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isHighlighted ? activeColor : inactiveColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: (textStyle ?? theme.textTheme.bodyMedium)?.copyWith(
                  color: isHighlighted ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: (isActive ? activeTextStyle : textStyle) ??
                theme.textTheme.bodyMedium?.copyWith(
                  color: isActive ? activeColor : Colors.grey,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;
  final Color activeColor;
  final Color inactiveColor;

  const _ProgressBar({
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: inactiveColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: 4,
              width: constraints.maxWidth * progress,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        );
      },
    );
  }
}
