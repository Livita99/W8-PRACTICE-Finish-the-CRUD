import '../../model/food.dart';

abstract class FoodRepository {
  Future<Food> addFood({required String name, required double price});
  Future<List<Food>> getFoods();
  Future<void> updateFood({
    required String id,
    required String name,
    required double price,
  });
  Future<void> deleteFood(String id);
}
