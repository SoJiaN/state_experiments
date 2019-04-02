import 'package:flutter/material.dart';
import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/catalog.dart';
import 'package:reactive_exploration/common/widgets/cart_button.dart';
import 'package:reactive_exploration/common/widgets/cart_page.dart';
import 'package:reactive_exploration/common/widgets/product_square.dart';
import 'package:reactive_exploration/common/widgets/theme.dart';
import 'package:scoped_model/scoped_model.dart';
import 'CartModel.dart';

void main() => runApp(MyApp());

final Cart cart = Cart();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  ScopedModel(
      model: CartModel(),
        child: MaterialApp(
      title: 'Start',
      theme: appTheme,
      home: MyHomePage(),
      routes: <String, WidgetBuilder>{
        CartPage.routeName: (context) => CartPage(cart)
      },
    ));
  }
}

/// The sample app's main page
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Start"),
        actions: <Widget>[
          ScopedModelDescendant<CartModel> (
            builder: (context, _, model) => CartButton(
              itemCount: model.itemCount,
              onPressed: () {
                Navigator.of(context).pushNamed(CartPage.routeName);
              },
            ),
          )

        ],
      ),
      body:  ProductGrid(),
    );
  }
}

/// Displays the contents of the cart
class CartContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(24.0),
      child: Text("Cart: ${cart.items}"));
}

/// Displays a tappable grid of products
class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GridView.count(
        crossAxisCount: 2,
        children: catalog.products.map((product) {
          return ScopedModelDescendant<CartModel> (
              rebuildOnChange: false,
              builder:(context, _, model) => ProductSquare(
                product: product,
                onTap: () => {
                  model.add(product)
                },
              )
          );
        }).toList(),
      );
}
