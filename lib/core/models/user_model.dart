class UserModel {
  final String name;
  final double height; // in cm
  final double weight; // in kg
  final int age;
  final String program;

  UserModel({
    required this.name,
    required this.height,
    required this.weight,
    required this.age,
    required this.program,
  });

  double get bmi => weight / ((height / 100) * (height / 100));

  String get bmiCategory {
    double val = bmi;
    if (val < 18.5) {
      return "You have a underweight";
    } else if (val < 25) {
      return "You have a normal weight";
    } else if (val < 30) {
      return "You have a overweight";
    } else {
      return "You have a obesity";
    }
  }
}
