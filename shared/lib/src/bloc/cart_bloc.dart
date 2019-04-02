import 'dart:async';

import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/cart_item.dart';
import 'package:reactive_exploration/common/models/product.dart';
import 'package:rxdart/subjects.dart';

class CartAddition {
  final Product product;
  final int count;

  CartAddition(this.product, [this.count = 1]);
}

class CartBloc {
  final Cart _cart = Cart();

  final BehaviorSubject<List<CartItem>> _items =
      BehaviorSubject<List<CartItem>>(seedValue: []); /// 使用 BehaviorSubject 每次订阅的时候，它都发射最近的数据

  final BehaviorSubject<int> _itemCount =
      BehaviorSubject<int>(seedValue: 0);

  final StreamController<CartAddition> _cartAdditionController =
      StreamController<CartAddition>();

  CartBloc() {
    _cartAdditionController.stream.listen((addition) { /// 输入流的Stream 监听添加product 给 cart的事件
      int currentCount = _cart.itemCount;
      _cart.add(addition.product, addition.count);
      _items.add(_cart.items); /// behaviorSubject 添加
      int updatedCount = _cart.itemCount;
      if (updatedCount != currentCount) {
        _itemCount.add(updatedCount); /// behaviorSubject 添加
      }
    });
  }

  Sink<CartAddition> get cartAddition => _cartAdditionController.sink; /// Sink 是输入的流，a input of stream,然后你再监听它的变化

  Stream<int> get itemCount => _itemCount.stream; /// 输出的流

  Stream<List<CartItem>> get items => _items.stream; /// 输出的流

  void dispose() {
    _items.close();
    _itemCount.close();
    _cartAdditionController.close();
  }
}
