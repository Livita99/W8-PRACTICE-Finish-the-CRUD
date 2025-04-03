import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/food.dart';
import '../providers/food_provider.dart';

class FoodForm extends StatelessWidget {
  final Food? food;

  const FoodForm({super.key, this.food});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController(
      text: food?.name ?? '',
    );
    final TextEditingController priceController = TextEditingController(
      text: food?.price.toString() ?? '',
    );

    return AlertDialog(
      title: Text(food == null ? "Add Food" : "Edit Food"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: "Name"),
          ),
          TextField(
            controller: priceController,
            decoration: InputDecoration(labelText: "Price"),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            final name = nameController.text;
            double price;

            try {
              price = double.parse(priceController.text);
            } catch (e) {
              price = 0.0; // Default to 0.0 if parsing fails
            }

            if (food == null) {
              // Add new food
              context.read<FoodProvider>().addFood(name, price);
            } else {
              // Edit existing food
              context.read<FoodProvider>().editFood(food!.id, name, price);
            }

            Navigator.pop(context);
          },
          child: Text("Save"),
        ),
      ],
    );
  }
}
