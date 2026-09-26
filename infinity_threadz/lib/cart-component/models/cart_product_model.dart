import 'package:infinity_threadz/product-catalogue-component/models/product_model.dart';

class CartProduct {
  final Product product;

  CartProduct({
    required this.product,
  });

  double? _subtotal;
  double get subtotal => _subtotal ?? product.price;
  set subtotal(double amount) => _subtotal = amount;
}
