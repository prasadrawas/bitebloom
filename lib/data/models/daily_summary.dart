import 'package:cloud_firestore/cloud_firestore.dart';

class DailySummary {
  final String date;
  final int totalCalories;
  // Macronutrients
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final double totalFiber;
  final double totalSugar;
  final double totalSaturatedFat;
  // Minerals
  final double totalSodium; // mg
  final double totalPotassium; // mg
  final double totalCalcium; // mg
  final double totalIron; // mg
  final double totalMagnesium; // mg
  // Vitamins
  final double totalVitaminA; // mcg
  final double totalVitaminC; // mg
  final double totalVitaminD; // mcg
  final double totalVitaminB12; // mcg

  final int waterIntake; // in ml
  final int streak;
  final bool goalMet;

  DailySummary({
    required this.date,
    this.totalCalories = 0,
    this.totalProtein = 0,
    this.totalCarbs = 0,
    this.totalFat = 0,
    this.totalFiber = 0,
    this.totalSugar = 0,
    this.totalSaturatedFat = 0,
    this.totalSodium = 0,
    this.totalPotassium = 0,
    this.totalCalcium = 0,
    this.totalIron = 0,
    this.totalMagnesium = 0,
    this.totalVitaminA = 0,
    this.totalVitaminC = 0,
    this.totalVitaminD = 0,
    this.totalVitaminB12 = 0,
    this.waterIntake = 0,
    this.streak = 0,
    this.goalMet = false,
  });

  factory DailySummary.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DailySummary(
      date: doc.id,
      totalCalories: data['totalCalories'] ?? 0,
      totalProtein: (data['totalProtein'] ?? 0).toDouble(),
      totalCarbs: (data['totalCarbs'] ?? 0).toDouble(),
      totalFat: (data['totalFat'] ?? 0).toDouble(),
      totalFiber: (data['totalFiber'] ?? 0).toDouble(),
      totalSugar: (data['totalSugar'] ?? 0).toDouble(),
      totalSaturatedFat: (data['totalSaturatedFat'] ?? 0).toDouble(),
      totalSodium: (data['totalSodium'] ?? 0).toDouble(),
      totalPotassium: (data['totalPotassium'] ?? 0).toDouble(),
      totalCalcium: (data['totalCalcium'] ?? 0).toDouble(),
      totalIron: (data['totalIron'] ?? 0).toDouble(),
      totalMagnesium: (data['totalMagnesium'] ?? 0).toDouble(),
      totalVitaminA: (data['totalVitaminA'] ?? 0).toDouble(),
      totalVitaminC: (data['totalVitaminC'] ?? 0).toDouble(),
      totalVitaminD: (data['totalVitaminD'] ?? 0).toDouble(),
      totalVitaminB12: (data['totalVitaminB12'] ?? 0).toDouble(),
      waterIntake: data['waterIntake'] ?? 0,
      streak: data['streak'] ?? 0,
      goalMet: data['goalMet'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFat': totalFat,
      'totalFiber': totalFiber,
      'totalSugar': totalSugar,
      'totalSaturatedFat': totalSaturatedFat,
      'totalSodium': totalSodium,
      'totalPotassium': totalPotassium,
      'totalCalcium': totalCalcium,
      'totalIron': totalIron,
      'totalMagnesium': totalMagnesium,
      'totalVitaminA': totalVitaminA,
      'totalVitaminC': totalVitaminC,
      'totalVitaminD': totalVitaminD,
      'totalVitaminB12': totalVitaminB12,
      'waterIntake': waterIntake,
      'streak': streak,
      'goalMet': goalMet,
    };
  }
}
