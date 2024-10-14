import 'package:daily_dish/logic/food_list/food_list_repository.dart';
import 'package:daily_dish/logic/food_list/food_list_state.dart';
import 'package:daily_dish/models/food.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodListCubit extends Cubit<FoodListState> {
  final FoodListRepository _foodListRepository;

  FoodListCubit(this._foodListRepository) : super(FoodsUninitialized());

  Future<void> getFoodList() async {
    try {
      emit(FoodsLoading());

      final foodList = await _foodListRepository.getFoodList();
      emit(FoodsLoaded(foodList));
    } catch (error, stacktrace) {
      emit(FoodsError('${error.toString()} \n {$stacktrace}'));
    }
  }

  Future<void> addFoodToList(Food food) async {
    try {
      emit(FoodsLoading());

      await _foodListRepository.saveFood(food);
      final foodList = await _foodListRepository.getFoodList();

      emit(FoodsLoaded(foodList));
    } catch (error, stacktrace) {
      emit(FoodsError('${error.toString()} \n {$stacktrace}'));
    }
  }

  Future<void> removeFoodFromList(Food food) async {
    try {
      emit(FoodsLoading());

      await _foodListRepository.deleteFood(food);
      final foodList = await _foodListRepository.getFoodList();

      emit(FoodsLoaded(foodList));
    } catch (error, stacktrace) {
      emit(FoodsError('${error.toString()} \n {$stacktrace}'));
    }
  }
}
