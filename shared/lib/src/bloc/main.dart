import 'package:flutter/material.dart';
import 'package:reactive_exploration/common/models/catalog.dart';
import 'package:reactive_exploration/common/widgets/cart_button.dart';
import 'package:reactive_exploration/common/widgets/product_square.dart';
import 'package:reactive_exploration/common/widgets/theme.dart';
import 'package:reactive_exploration/src/bloc/bloc_cart_page.dart';
import 'package:reactive_exploration/src/bloc/cart_bloc.dart';
import 'package:reactive_exploration/src/bloc/cart_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CartProvider(
      child: MaterialApp(
        title: 'Bloc',
        theme: appTheme,
        home: MyHomePage(),
        routes: <String, WidgetBuilder>{
          BlocCartPage.routeName: (context) => BlocCartPage()
        },
      ),
    );
  }
}

/// The sample app's main page
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartBloc = CartProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Bloc"),
        actions: <Widget>[
          StreamBuilder<int>( /// 将 CartButton 包装在 StreamBuilder 中， int 是 cartBloc ItemCount 的数据类型
            stream: cartBloc.itemCount,
            initialData: 0, /// 初始值
            builder: (context, snapshot) => CartButton(
                  itemCount: snapshot.data, /// 对显示的数据进行跟新，更新UI
                  onPressed: () {
                    Navigator.of(context).pushNamed(BlocCartPage.routeName);
                  },
                ),
          )
        ],
      ),
      body: ProductGrid(),
    );
  }
}

/// Displays a tappable grid of products
class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartBloc = CartProvider.of(context);
    return GridView.count(
      crossAxisCount: 2,
      children: catalog.products.map((product) {
        return ProductSquare(
          product: product,
          onTap: () {
            cartBloc.cartAddition.add(CartAddition(product));
          },
        );
      }).toList(),
    );
  }
}
