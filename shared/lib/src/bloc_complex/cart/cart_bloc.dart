import 'dart:async';

import 'package:reactive_exploration/common/models/cart_item.dart';
import 'package:reactive_exploration/common/models/product.dart';
import 'package:reactive_exploration/src/bloc_complex/services/cart.dart';
import 'package:rxdart/rxdart.dart';

class CartAddition {
  final Product product;
  final int count;

  CartAddition(this.product, [this.count = 1]);
}

class CartBloc {
  // This is the internal state. It's mostly a helper object so that the code
  // in this class only deals with streams.
  final _cart = CartService();

  // These are the internal objects whose streams / sinks are provided
  // by this component. See below for what each means.
  final _items = BehaviorSubject<List<CartItem>>(seedValue: []); /// input
  final _itemCount = BehaviorSubject<int>(seedValue: 0); /// output
  final _cartAdditionController = StreamController<CartAddition>(); /// StreamBuilder 是flutter basic library 的东西，帮助我们去监听一个Stream

  CartBloc() {
    _cartAdditionController.stream.listen(_handleAddition); /// 监听数据变化
  }

  /// This is the input of additions to the cart. Use this to signal
  /// to the component that user is trying to buy a product.
  Sink<CartAddition> get cartAddition => _cartAdditionController.sink; /// 使用在 product_grid/product_grid.dart 中

  /// This stream has a new value whenever the count of items in the cart
  /// changes.
  ///
  /// We're using the `distinct()` transform so that only values that are
  /// in fact a change will be published by the stream.
  ValueObservable<int> get itemCount => _itemCount
      .distinct()
      // Since we're using the distinct operator, we need to convert back
      // to a ValueObservable using shareValue.
      .shareValue(seedValue: 0);

  /// This is the stream of items in the cart. Use this to show the contents
  /// of the cart when you need all the information in [CartItem].
  ValueObservable<List<CartItem>> get items => _items.stream;

  /// Take care of closing streams.
  void dispose() {
    _items.close();
    _itemCount.close();
    _cartAdditionController.close();
  }

  /// Business logic for adding products to cart. Adds new events to outputs
  /// as needed.
  void _handleAddition(CartAddition addition) {
    _cart.add(addition.product, addition.count); /// 产品作为数据流输入进来，
    _items.add(_cart.items); /// 保证每次产品被添加到购物车之后，itemCount都发生了变化
    _itemCount.add(_cart.itemCount); /// 将 itemCount 添加到 itemCountStream 中
  }
}
