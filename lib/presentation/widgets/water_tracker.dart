import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

class WaterTracker extends StatelessWidget {
  final int currentMl;
  final int targetMl;
  final VoidCallback onAdd;

  const WaterTracker({
    super.key,
    required this.currentMl,
    this.targetMl = 2500,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final progress =
        targetMl > 0 ? (currentMl / targetMl).clamp(0.0, 1.0) : 0.0;
    final glasses = (currentMl / 250).floor();
    final percentage = (progress * 100).round();
    final isComplete = currentMl >= targetMl;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.water.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.water_drop,
                        color: AppColors.water, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Water Intake',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                      Text(
                        '${currentMl}ml / ${targetMl}ml',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.white30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isComplete
                      ? AppColors.accentGreen.withValues(alpha: 0.12)
                      : AppColors.water.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isComplete ? 'Done!' : '$percentage%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color:
                        isComplete ? AppColors.accentGreen : AppColors.water,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Glass indicators
          Row(
            children: List.generate(10, (i) {
              final isFilled = i < glasses;
              return Expanded(
                child: Container(
                  height: 20,
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  decoration: BoxDecoration(
                    color: isFilled
                        ? AppColors.water.withValues(alpha: 0.7)
                        : AppColors.water.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$glasses glasses',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.white30,
                ),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onAdd();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.water.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.water.withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: AppColors.water, size: 16),
                      SizedBox(width: 4),
                      Text(
                        '250ml',
                        style: TextStyle(
                          color: AppColors.water,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
