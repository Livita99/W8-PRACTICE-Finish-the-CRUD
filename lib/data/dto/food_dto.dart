import '../../model/food.dart';

class FoodDto {
  static Food fromJson(String id, Map<String, dynamic> json) {
    return Food(id: id, name: json['name'], price: json['price']);
  }

  static Map<String, dynamic> toJson(Food food) {
    return {'name': food.name, 'price': food.price};
  }
}
