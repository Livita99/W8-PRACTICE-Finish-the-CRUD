import '../../../model/food.dart';
import '../food_repository.dart';

class MockFoodRepository extends FoodRepository {
  final List<Food> foods = [];

  @override
  Future<Food> addFood({required String name, required double price}) {
    return Future.delayed(Duration(seconds: 1), () {
      Food newFood = Food(id: "0", name: name, price: 12);
      foods.add(newFood);
      return newFood;
    });
  }

  @override
  Future<List<Food>> getFoods() {
    return Future.delayed(Duration(seconds: 1), () => foods);
  }

  @override
  Future<void> updateFood({
    required String id,
    required String name,
    required double price,
  }) async {
    final index = foods.indexWhere((food) => food.id == id);
    if (index != -1) {
      foods[index] = Food(id: id, name: name, price: price);
    }
  }

  @override
  Future<void> deleteFood(String id) async {
    foods.removeWhere((food) => food.id == id);
  }
}
