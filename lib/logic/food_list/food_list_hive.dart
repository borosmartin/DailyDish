import 'package:daily_dish/models/food.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FoodListHive {
  static const String foodListBoxKey = 'FoodListBoxKey';
  static const String foodListKey = 'FoodListKey';

  Future<void> addFoodToHive(Food food) async {
    final box = await Hive.openBox(foodListBoxKey);

    List<Food> existingFoodList = await getFoodListFromHive();
    existingFoodList.add(food);

    List<Map<String, dynamic>> foodListMap = [];
    for (var i = 0; i < existingFoodList.length; i++) {
      foodListMap.add(existingFoodList[i].toJson());
    }

    box.put(foodListKey, foodListMap);
  }

  Future<void> deleteFoodFromHive(Food food) async {
    final box = await Hive.openBox(foodListBoxKey);
    final boxValue = box.get(foodListKey);

    if (boxValue != null) {
      List<Food> existingFoodList = await getFoodListFromHive();
      existingFoodList.remove(food);

      List<Map<String, dynamic>> foodListMap = [];
      for (var i = 0; i < existingFoodList.length; i++) {
        foodListMap.add(existingFoodList[i].toJson());
      }

      box.put(foodListKey, foodListMap);
    }
  }

  Future<List<Food>> getFoodListFromHive() async {
    final box = await Hive.openBox(foodListBoxKey);
    final boxValue = box.get(foodListKey);

    if (boxValue != null) {
      List<Food> result = [];

      for (var i = 0; i < boxValue.length; i++) {
        final food = Food.fromJson(boxValue[i]);

        if (food.foodType == FoodType.soup) {
          result.add(Soup.fromJson(boxValue[i]));
        } else if (food.foodType == FoodType.main) {
          result.add(MainCourse.fromJson(boxValue[i]));
        } else if (food.foodType == FoodType.dessert) {
          result.add(Dessert.fromJson(boxValue[i]));
        }
      }

      return result;
    } else {
      return [];
    }
  }
}
