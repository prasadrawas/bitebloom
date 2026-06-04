import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/theme_colors.dart';

class BmiBmrInfoScreen extends StatelessWidget {
  final double bmi;
  final double bmr;
  final String category;

  const BmiBmrInfoScreen({
    super.key,
    required this.bmi,
    required this.bmr,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.of(context).bg,
      appBar: AppBar(title: const Text('BMI & BMR')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Your Stats
            _statsCard(context),
            const SizedBox(height: 24),

            // What is BMI
            _sectionTitle(context, 'What is BMI?'),
            const SizedBox(height: 8),
            _bodyText(context,
                'Body Mass Index (BMI) is a simple measure that uses your height and weight to estimate whether you are underweight, normal weight, overweight, or obese. It is calculated as weight (kg) divided by height (m) squared.'),
            const SizedBox(height: 16),

            // BMI Table
            _bmiTable(context),
            const SizedBox(height: 24),

            // What is BMR
            _sectionTitle(context, 'What is BMR?'),
            const SizedBox(height: 8),
            _bodyText(context,
                'Basal Metabolic Rate (BMR) is the number of calories your body needs to perform basic life-sustaining functions like breathing, circulation, and cell production while at complete rest.'),
            const SizedBox(height: 12),
            _bodyText(context,
                'BiteBloom uses the Mifflin-St Jeor equation to calculate your BMR, which is considered the most accurate formula for estimating metabolic rate.'),
            const SizedBox(height: 24),

            // How we calculate
            _sectionTitle(context, 'How Your Targets Are Set'),
            const SizedBox(height: 8),
            _stepCard(context, '1', 'BMR Calculated',
                'Using your age, weight, height, and gender with the Mifflin-St Jeor formula.'),
            const SizedBox(height: 8),
            _stepCard(context, '2', 'Activity Multiplied',
                'Your BMR is multiplied by your activity level to get your Total Daily Energy Expenditure (TDEE).'),
            const SizedBox(height: 8),
            _stepCard(context, '3', 'Goal Adjusted',
                'Lose: TDEE - 500 kcal deficit\nMaintain: TDEE as-is\nGain: TDEE + 300 kcal surplus'),
            const SizedBox(height: 8),
            _stepCard(context, '4', 'Macros Split',
                'Your calorie target is split into protein, carbs, and fat based on your goal.'),
            const SizedBox(height: 24),

            // Disclaimer
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline,
                      color: AppColors.warning, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'BMI and BMR are general estimates and may not apply to athletes, elderly, pregnant women, or growing children. Consult a healthcare professional for personalized advice.',
                      style: TextStyle(
                        color: C.of(context).text70,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 500.ms),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _statsCard(BuildContext context) {
    final categoryColor = bmi < 18.5
        ? AppColors.water
        : bmi < 25
            ? AppColors.accentGreen
            : bmi < 30
                ? AppColors.warning
                : AppColors.error;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: C.of(context).card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: C.of(context).glassBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text('Your BMI',
                    style: TextStyle(
                        color: C.of(context).text54,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(bmi.toStringAsFixed(1),
                    style: TextStyle(
                        color: categoryColor,
                        fontSize: 32,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(category,
                      style: TextStyle(
                          color: categoryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          Container(
              width: 1, height: 60, color: C.of(context).glassBorder),
          Expanded(
            child: Column(
              children: [
                Text('Your BMR',
                    style: TextStyle(
                        color: C.of(context).text54,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(bmr.round().toString(),
                    style: TextStyle(
                        color: C.of(context).text,
                        fontSize: 32,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text('kcal/day',
                    style: TextStyle(
                        color: C.of(context).text54,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, end: 0);
  }

  Widget _bmiTable(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: C.of(context).card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: C.of(context).glassBorder),
      ),
      child: Column(
        children: [
          _bmiRow(context, 'Underweight', '< 18.5', AppColors.water,
              bmi < 18.5),
          Divider(height: 1, color: C.of(context).glassBorder),
          _bmiRow(context, 'Normal', '18.5 – 24.9', AppColors.accentGreen,
              bmi >= 18.5 && bmi < 25),
          Divider(height: 1, color: C.of(context).glassBorder),
          _bmiRow(context, 'Overweight', '25.0 – 29.9', AppColors.warning,
              bmi >= 25 && bmi < 30),
          Divider(height: 1, color: C.of(context).glassBorder),
          _bmiRow(
              context, 'Obese', '≥ 30.0', AppColors.error, bmi >= 30),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 200.ms);
  }

  Widget _bmiRow(BuildContext context, String label, String range,
      Color color, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: isActive ? color.withValues(alpha: 0.08) : Colors.transparent,
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: TextStyle(
                    color: isActive ? color : C.of(context).text70,
                    fontWeight:
                        isActive ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 14)),
          ),
          Text(range,
              style: TextStyle(
                  color: C.of(context).text54,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
          if (isActive) ...[
            const SizedBox(width: 8),
            Icon(Icons.arrow_back, color: color, size: 14),
          ],
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        color: C.of(context).text,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 100.ms);
  }

  Widget _bodyText(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        color: C.of(context).text70,
        fontSize: 14,
        height: 1.6,
      ),
    );
  }

  Widget _stepCard(
      BuildContext context, String number, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: C.of(context).card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: C.of(context).glassBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.accentGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(number,
                  style: TextStyle(
                      color: AppColors.accentGreen,
                      fontSize: 14,
                      fontWeight: FontWeight.w800)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: C.of(context).text,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(desc,
                    style: TextStyle(
                        color: C.of(context).text54,
                        fontSize: 13,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 300.ms);
  }
}
