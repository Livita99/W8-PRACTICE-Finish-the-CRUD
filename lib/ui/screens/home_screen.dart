import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/food.dart';
import '../providers/food_provider.dart';
import '../widgets/food_form.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showFoodForm(BuildContext context, {Food? food}) {
    showDialog(context: context, builder: (context) => FoodForm(food: food));
  }

  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context);

    Widget content = Text('');
    if (foodProvider.isLoading) {
      content = Center(child: CircularProgressIndicator());
    } else if (foodProvider.hasData) {
      List<Food> foods = foodProvider.foodsState!.data!;

      if (foods.isEmpty) {
        content = Text("No data yet");
      } else {
        content = ListView.builder(
          itemCount: foods.length,
          itemBuilder:
              (context, index) => ListTile(
                title: Text(foods[index].name),
                subtitle: Text("${foods[index].price}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed:
                          () => _showFoodForm(context, food: foods[index]),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed:
                          () => context.read<FoodProvider>().removeFood(
                            foods[index].id,
                          ),
                    ),
                  ],
                ),
              ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[200],
        title: const Text("Food List"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _showFoodForm(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(child: content),
    );
  }
}
