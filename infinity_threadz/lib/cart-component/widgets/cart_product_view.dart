import 'package:flutter/material.dart';
import 'package:infinity_threadz/product-catalogue-component/models/product_model.dart';
import 'package:infinity_threadz/product-catalogue-component/widgets/read_more_text.dart';
import 'package:intl/intl.dart';

class CartProductWidget extends StatefulWidget {
  final Product product;
  final Function(Product product) onRemoveFromCartPressed;
  final Function(Product product, double subtotal) onSubtotalChanged;
  const CartProductWidget({
    super.key,
    required this.product,
    required this.onRemoveFromCartPressed,
    required this.onSubtotalChanged,
  });

  @override
  State<StatefulWidget> createState() => _CartProductWidget();
}

class _CartProductWidget extends State<CartProductWidget> {
  late NumberFormat formatCurrency;

  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    formatCurrency = NumberFormat.simpleCurrency(locale: 'af');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: Theme.of(context).cardTheme.margin,
      child: Column(
        children: [
          buildProductImage(),
          buildProductDetails(),
          buildQuantitySelector(),
          buildProductTotals(),
        ],
      ),
    );
  }

  Widget buildProductImage() {
    return Expanded(
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 150,
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                image: DecorationImage(
                  image: ResizeImage(
                    AssetImage(widget.product.image),
                    width: 1000,
                    height: 1000,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.red,
                size: 28,
              ),
              onPressed: () => widget.onRemoveFromCartPressed(widget.product),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductDetails() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.product.name,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.titleLarge?.merge(
                    const TextStyle(
                      fontFamily: 'Galada',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: ReadMoreTextWidget(
              text: widget.product.description,
              style: Theme.of(context).textTheme.bodyMedium!.merge(
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQuantitySelector() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: _quantity > 1 ? () => onQuantityDecreased() : null,
          ),
          Text(
            _quantity.toString(),
            style: Theme.of(context).textTheme.bodyLarge?.merge(
                  const TextStyle(
                    fontFamily: 'Galada',
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => onQuantityIncreased(),
          ),
        ],
      ),
    );
  }

  Widget buildProductTotals() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price:',
                style: Theme.of(context).textTheme.bodyLarge?.merge(
                      const TextStyle(
                        fontFamily: 'Galada',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              ),
              Text(
                formatCurrency.format(widget.product.price),
                style: Theme.of(context).textTheme.bodyLarge?.merge(
                      const TextStyle(
                        fontFamily: 'Galada',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal:',
                style: Theme.of(context).textTheme.bodyLarge?.merge(
                      const TextStyle(
                        fontFamily: 'Galada',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              ),
              Text(
                formatCurrency.format(calcSubtotal()),
                style: Theme.of(context).textTheme.bodyLarge?.merge(
                      const TextStyle(
                        fontFamily: 'Galada',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double calcSubtotal() {
    double subtotal = widget.product.price * _quantity;
    return subtotal;
  }

  void onQuantityDecreased() {
    _quantity = _quantity - 1;
    widget.onSubtotalChanged(widget.product, calcSubtotal());
    setState(() {});
  }

  onQuantityIncreased() {
    _quantity = _quantity + 1;
    widget.onSubtotalChanged(widget.product, calcSubtotal());
    setState(() {});
  }
}
