import 'package:daily_dish/home_page.dart';
import 'package:daily_dish/logic/food_list/food_list_cubit.dart';
import 'package:daily_dish/logic/food_list/food_list_hive.dart';
import 'package:daily_dish/logic/food_list/food_list_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();

  runApp(const DailyDish());
}

class DailyDish extends StatelessWidget {
  const DailyDish({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: _getRepositoryProviders(),
      child: MultiBlocProvider(
        providers: _getBlocProviders(),
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomePage(),
        ),
      ),
    );
  }

  List<RepositoryProvider> _getRepositoryProviders() {
    return [
      RepositoryProvider<FoodListRepository>(
        create: (context) => FoodListRepository(FoodListHive()),
      ),
    ];
  }

  List<BlocProvider> _getBlocProviders() {
    return [
      BlocProvider<FoodListCubit>(
        create: (context) => FoodListCubit(
          RepositoryProvider.of<FoodListRepository>(context),
        ),
      ),
    ];
  }
}
