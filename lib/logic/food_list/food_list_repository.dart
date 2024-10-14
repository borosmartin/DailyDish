import 'package:daily_dish/logic/food_list/food_list_hive.dart';
import 'package:daily_dish/models/food.dart';

class FoodListRepository {
  final FoodListHive _foodListHive;

  FoodListRepository(this._foodListHive);

  Future<void> saveFood(Food food) async {
    await _foodListHive.addFoodToHive(food);
  }

  Future<void> deleteFood(Food food) async {
    await _foodListHive.deleteFoodFromHive(food);
  }

  Future<List<Food>> getFoodList() async {
    return await _foodListHive.getFoodListFromHive();
  }
}
