import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../model/food.dart';
import '../../dto/food_dto.dart';
import '../food_repository.dart';

class FirebaseFoodRepository extends FoodRepository {
  static const String baseUrl =
      'https://week8-crud-food-list-98a62-default-rtdb.asia-southeast1.firebasedatabase.app';
  static const String foodsCollection = "foodsCollection";
  static const String allFoodsUrl = '$baseUrl/$foodsCollection.json';

  @override
  Future<Food> addFood({required String name, required double price}) async {
    Uri uri = Uri.parse(allFoodsUrl);

    // Create a new data
    final newFoodData = {'name': name, 'price': price};
    final http.Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newFoodData),
    );

    // Handle errors
    if (response.statusCode != HttpStatus.ok &&
        response.statusCode != HttpStatus.created) {
      throw Exception('Failed to add food');
    }

    // Firebase returns the new ID in 'name'
    final newId = json.decode(response.body)['name'];

    // Return the created food item
    return Food(id: newId, name: name, price: price);
  }

  @override
  Future<List<Food>> getFoods() async {
    Uri uri = Uri.parse(allFoodsUrl);
    final http.Response response = await http.get(uri);

    // Handle errors
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to load');
    }

    // Return all users
    final data = json.decode(response.body) as Map<String, dynamic>?;

    if (data == null) return [];
    return data.entries
        .map((entry) => FoodDto.fromJson(entry.key, entry.value))
        .toList();
  }

  @override
  Future<void> updateFood({
    required String id,
    required String name,
    required double price,
  }) async {
    Uri uri = Uri.parse('$baseUrl/$foodsCollection/$id.json');
    final updatedFoodData = {'name': name, 'price': price};

    final response = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedFoodData),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to update food');
    }
  }

  @override
  Future<void> deleteFood(String id) async {
    Uri uri = Uri.parse('$baseUrl/$foodsCollection/$id.json');

    final response = await http.delete(uri);

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to delete food');
    }
  }
}
