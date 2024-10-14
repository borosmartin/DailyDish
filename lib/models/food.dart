import 'package:equatable/equatable.dart';

enum FoodType { soup, main, dessert }

FoodType _getFoodTypeFromJson(String foodType) {
  FoodType result;

  switch (foodType) {
    case 'FoodType.soup':
      result = FoodType.soup;
      break;
    case 'FoodType.main':
      result = FoodType.main;
      break;
    case 'FoodType.dessert':
      result = FoodType.dessert;
      break;
    default:
      result = FoodType.main;
  }

  return result;
}

class Food extends Equatable {
  final String name;
  final FoodType foodType;
  final DateTime? lastCoocked;

  const Food({required this.name, required this.foodType, this.lastCoocked});

  factory Food.fromJson(Map json) {
    return Food(
      name: json['name'],
      foodType: _getFoodTypeFromJson(json['foodType']),
      lastCoocked: json['lastCoocked'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'foodType': foodType.toString(),
      'lastCoocked': lastCoocked,
    };
  }

  @override
  List<Object?> get props => [name, foodType, lastCoocked];
}

//----------------------------------------------------------------------------//
enum SoupType { sweet, savory }

class Soup extends Food {
  final SoupType soupType;

  const Soup({required super.name, super.foodType = FoodType.soup, super.lastCoocked, required this.soupType});

  factory Soup.fromJson(Map json) {
    SoupType soupType;
    switch (json['soupType']) {
      case 'SoupType.sweet':
        soupType = SoupType.sweet;
        break;
      case 'SoupType.savory':
        soupType = SoupType.savory;
        break;
      default:
        soupType = SoupType.sweet;
    }

    return Soup(
      name: json['name'],
      foodType: _getFoodTypeFromJson(json['foodType']),
      lastCoocked: json['lastCoocked'],
      soupType: soupType,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'foodType': foodType.toString(),
      'lastCoocked': lastCoocked,
      'soupType': soupType.toString(),
    };
  }

  @override
  List<Object?> get props => [name, foodType, lastCoocked, soupType];
}

//----------------------------------------------------------------------------//
enum MainCourseType { meat, pasta, vegan, sidedish }

class MainCourse extends Food {
  final MainCourseType mainCourseType;

  const MainCourse({required super.name, super.foodType = FoodType.main, super.lastCoocked, required this.mainCourseType});

  factory MainCourse.fromJson(Map json) {
    MainCourseType mainCourseType;
    switch (json['mainCourseType']) {
      case 'MainCourseType.meat':
        mainCourseType = MainCourseType.meat;
        break;
      case 'MainCourseType.pasta':
        mainCourseType = MainCourseType.pasta;
        break;
      case 'MainCourseType.vegan':
        mainCourseType = MainCourseType.vegan;
        break;
      case 'MainCourseType.sidedish':
        mainCourseType = MainCourseType.sidedish;
        break;
      default:
        mainCourseType = MainCourseType.meat;
    }

    return MainCourse(
      name: json['name'],
      foodType: _getFoodTypeFromJson(json['foodType']),
      lastCoocked: json['lastCoocked'],
      mainCourseType: mainCourseType,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'foodType': foodType.toString(),
      'lastCoocked': lastCoocked,
      'mainCourseType': mainCourseType.toString(),
    };
  }

  @override
  List<Object?> get props => [name, foodType, lastCoocked, mainCourseType];
}

//----------------------------------------------------------------------------//
enum DessertType { sweet, savory }

class Dessert extends Food {
  final DessertType dessertType;

  const Dessert({required super.name, super.foodType = FoodType.dessert, super.lastCoocked, required this.dessertType});

  factory Dessert.fromJson(Map json) {
    DessertType dessertType;
    switch (json['dessertType']) {
      case 'DessertType.sweet':
        dessertType = DessertType.sweet;
        break;
      case 'DessertType.savory':
        dessertType = DessertType.savory;
        break;
      default:
        dessertType = DessertType.sweet;
    }

    return Dessert(
      name: json['name'],
      foodType: _getFoodTypeFromJson(json['foodType']),
      lastCoocked: json['lastCoocked'],
      dessertType: dessertType,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'foodType': foodType.toString(),
      'lastCoocked': lastCoocked,
      'dessertType': dessertType.toString(),
    };
  }

  @override
  List<Object?> get props => [name, foodType, lastCoocked, dessertType];
}
