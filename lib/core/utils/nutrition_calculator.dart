/// Mifflin-St Jeor equation for BMR and macro target calculation
class NutritionCalculator {
  /// Calculate BMI (Body Mass Index)
  /// weight in kg, height in cm
  static double calculateBMI({
    required double weight,
    required double height,
  }) {
    final w = weight.clamp(20.0, 500.0);
    final h = height.clamp(50.0, 300.0);
    final heightM = h / 100;
    return (w / (heightM * heightM)).clamp(5.0, 100.0);
  }

  /// Get BMI category label
  static String bmiCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  /// Calculate BMR using Mifflin-St Jeor formula
  /// weight in kg, height in cm, age in years
  /// gender: 'male' or 'female'
  static double calculateBMR({
    required double weight,
    required double height,
    required int age,
    String gender = 'male',
  }) {
    final w = weight.clamp(20.0, 500.0);
    final h = height.clamp(50.0, 300.0);
    final a = age.clamp(1, 120);
    double bmr;
    if (gender == 'male') {
      bmr = 10 * w + 6.25 * h - 5 * a + 5;
    } else {
      bmr = 10 * w + 6.25 * h - 5 * a - 161;
    }
    return bmr.clamp(500.0, 10000.0);
  }

  /// Calculate TDEE based on activity level (default: moderately active 1.55)
  static double calculateTDEE({
    required double bmr,
    double activityMultiplier = 1.55,
  }) {
    return bmr * activityMultiplier;
  }

  /// Calculate daily calorie target based on goal
  static int calculateCalorieTarget({
    required double weight,
    required double height,
    required int age,
    required String goal,
    String gender = 'male',
    double activityMultiplier = 1.55,
  }) {
    final bmr = calculateBMR(
      weight: weight,
      height: height,
      age: age,
      gender: gender,
    );
    final tdee = calculateTDEE(bmr: bmr, activityMultiplier: activityMultiplier);

    switch (goal) {
      case 'lose':
        return (tdee - 500).round(); // 500 cal deficit
      case 'gain':
        return (tdee + 300).round(); // 300 cal surplus
      case 'maintain':
      default:
        return tdee.round();
    }
  }

  /// Calculate macro targets in grams based on calorie target
  /// Balanced split: 30% protein, 40% carbs, 30% fat
  static Map<String, int> calculateMacroTargets({
    required int calorieTarget,
    required String goal,
  }) {
    double proteinPct, carbsPct, fatPct;

    switch (goal) {
      case 'lose':
        proteinPct = 0.35;
        carbsPct = 0.35;
        fatPct = 0.30;
        break;
      case 'gain':
        proteinPct = 0.30;
        carbsPct = 0.45;
        fatPct = 0.25;
        break;
      case 'maintain':
      default:
        proteinPct = 0.30;
        carbsPct = 0.40;
        fatPct = 0.30;
    }

    return {
      'protein': ((calorieTarget * proteinPct) / 4).round(), // 4 cal/g
      'carbs': ((calorieTarget * carbsPct) / 4).round(),     // 4 cal/g
      'fat': ((calorieTarget * fatPct) / 9).round(),         // 9 cal/g
    };
  }
}
