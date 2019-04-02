import 'package:scoped_model/scoped_model.dart';

import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/models/cart_item.dart';
import 'package:reactive_exploration/common/models/product.dart';

class CartModel extends Model {
  final _cart = Cart(); /// cart object , 这个里面保存我们的数据

  List<CartItem> get items => _cart.items; ///getter 拉去所有的cart items

  int get itemCount => _cart.itemCount; /// getter 得到购物车里的所有数目

  void add(Product product) { /// 将产品加入购物车，
    _cart.add(product);
    notifyListeners();
  }
}
