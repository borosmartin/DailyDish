import 'package:daily_dish/models/food.dart';
import 'package:equatable/equatable.dart';

class FoodListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FoodsUninitialized extends FoodListState {}

class FoodsLoading extends FoodListState {}

class FoodsLoaded extends FoodListState {
  final List<Food> foodList;

  FoodsLoaded(this.foodList);

  @override
  List<Object?> get props => [foodList];
}

class FoodsError extends FoodListState {
  final String message;

  FoodsError(this.message);

  @override
  List<Object?> get props => [message];
}
