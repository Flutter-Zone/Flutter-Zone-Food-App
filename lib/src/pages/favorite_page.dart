import 'package:flutter/material.dart';
import 'package:food_app_flutter_zone/src/models/food_model.dart';
import 'package:food_app_flutter_zone/src/scoped-model/main_model.dart';
import 'package:food_app_flutter_zone/src/widgets/food_item_card.dart';
import 'package:food_app_flutter_zone/src/widgets/small_button.dart';
import 'package:scoped_model/scoped_model.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 60.0),
        child: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
            model.fetchFoods();
            List<Food> foods = model.foods;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: foods.map((Food food){
                return FoodItemCard(
                  food.name,
                  food.description,
                  food.price.toString(),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
