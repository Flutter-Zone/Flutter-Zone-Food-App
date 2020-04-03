import 'package:flutter/material.dart';
import 'package:food_app_flutter_zone/src/widgets/button.dart';

class AddFoodItem extends StatefulWidget {
  AddFoodItem({Key key}) : super(key: key);

  @override
  _AddFoodItemState createState() => _AddFoodItemState();
}

class _AddFoodItemState extends State<AddFoodItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 60.0, horizontal: 16.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Form(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 15.0),

                width: MediaQuery.of(context).size.width,
                height: 170.0,
                
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10.0)
                ),
              ),
              _buildTextFormField("Food Title"),
              _buildTextFormField("Category"),
              _buildTextFormField("Description", maxLine: 5),
              _buildTextFormField("Price"),
              _buildTextFormField("Discount"),
              SizedBox(height: 130.0,),
              Button(btnText: "Add Food Item"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String hint, {int maxLine = 1}) {
    return TextFormField(
      decoration: InputDecoration(hintText: "$hint"),
      maxLines: maxLine,
      keyboardType: hint == "Price" || hint == "Discount" ?  TextInputType.number : TextInputType.text,
    );
  }
}
