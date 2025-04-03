import 'package:flutter/material.dart';

import '../../data/repository/food_repository.dart';
import '../../model/food.dart';
import 'async_value.dart';

class FoodProvider extends ChangeNotifier {
  final FoodRepository _repository;
  AsyncValue<List<Food>>? foodsState;

  FoodProvider(this._repository) {
    fetchFoods();
  }

  bool get isLoading =>
      foodsState != null && foodsState!.state == AsyncValueState.loading;
  bool get hasData =>
      foodsState != null && foodsState!.state == AsyncValueState.success;

  Future<void> fetchFoods() async {
    try {
      // 1- loading state
      foodsState = AsyncValue.loading();
      notifyListeners();

      // 2 - Fetch users
      foodsState = AsyncValue.success(await _repository.getFoods());

      print("SUCCESS: list size ${foodsState!.data!.length.toString()}");

      // 3 - Handle errors
    } catch (error) {
      print("ERROR: $error");
      foodsState = AsyncValue.error(error);
    }

    notifyListeners();
  }

  void addFood(String name, double price) async {
    // Optimistically add the item to the local cache
    final currentFoods = foodsState?.data ?? [];
    final newFood = Food(
      id: DateTime.now().toString(),
      name: name,
      price: price,
    );

    // Update the local state
    foodsState = AsyncValue.success([...currentFoods, newFood]);
    notifyListeners();

    try {
      // Perform the asynchronous addition and get the actual added food
      final addedFood = await _repository.addFood(name: name, price: price);

      // Replace the temporary item with the actual item from the repository
      foodsState = AsyncValue.success([
        ...foodsState!.data!.where((food) => food.id != newFood.id),
        addedFood,
      ]);
      notifyListeners();
    } catch (error) {
      print("ERROR: $error");

      // Recover by removing the optimistically added item
      foodsState = AsyncValue.success(
        foodsState!.data!.where((food) => food.id != newFood.id).toList(),
      );
      notifyListeners();
    }
  }

  void editFood(String id, String name, double price) async {
    // Optimistically update the item in the local cache
    final currentFoods = foodsState?.data ?? [];
    final updatedFoods =
        currentFoods.map((food) {
          if (food.id == id) {
            return Food(
              id: food.id,
              name: name,
              price: price,
            ); // Optimistic update
          }
          return food;
        }).toList();

    // Update the local state
    foodsState = AsyncValue.success(updatedFoods);
    notifyListeners();

    try {
      // Perform the asynchronous update
      await _repository.updateFood(id: id, name: name, price: price);
    } catch (error) {
      print("ERROR: $error");

      // Recover by restoring the previous state
      foodsState = AsyncValue.success(currentFoods);
      notifyListeners();
    }
  }

  void removeFood(String id) async {
    // Optimistically remove the item from the local cache
    final currentFoods = foodsState?.data ?? [];
    final removedFood = currentFoods.firstWhere(
      (food) => food.id == id,
      orElse: () {
        throw Exception("Food with id $id not found");
      },
    );

    // Update the local state
    foodsState = AsyncValue.success(
      currentFoods.where((food) => food.id != id).toList(),
    );
    notifyListeners();

    try {
      // Perform the asynchronous deletion
      await _repository.deleteFood(id);
    } catch (error) {
      print("ERROR: $error");

      // Recover by adding the item back to the cache
      foodsState = AsyncValue.success([...foodsState!.data!, removedFood]);
      notifyListeners();
    }
  }
}
