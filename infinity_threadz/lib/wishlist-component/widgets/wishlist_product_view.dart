import 'package:flutter/material.dart';
import 'package:infinity_threadz/product-catalogue-component/models/product_model.dart';
import 'package:infinity_threadz/product-catalogue-component/widgets/read_more_text.dart';
import 'package:intl/intl.dart';

class WishlistProductWidget extends StatefulWidget {
  final Product product;
  final Function(Product product) onRemoveFromWishlistPressed;
  final Function(Product product) onAddToCartPressed;
  const WishlistProductWidget({
    super.key,
    required this.product,
    required this.onRemoveFromWishlistPressed,
    required this.onAddToCartPressed,
  });

  @override
  State<StatefulWidget> createState() => _WishlistProductWidget();
}

class _WishlistProductWidget extends State<WishlistProductWidget> {
  late NumberFormat formatCurrency;

  @override
  void initState(){
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
          buildPriceDetails(),
          buildButtonBar(),
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
              onPressed: () =>
                  widget.onRemoveFromWishlistPressed(widget.product),
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

  Widget buildPriceDetails() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ImageIcon(
            ResizeImage(
              AssetImage('assets/images/banknotes.png'),
              width: 70,
              height: 70,
              allowUpscaling: false,
            ),
            size: 25,
            color: Colors.green,
          ),
          const SizedBox(width: 8),
          Container(
            margin: const EdgeInsets.only(top: 4.5),
            child: Text(
              formatCurrency.format(widget.product.price),
              style: const TextStyle(
                fontFamily: 'Galada',
                fontSize: 18,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtonBar() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: OverflowBar(
        alignment: MainAxisAlignment.end,
        spacing: 8,
        children: [
          InkWell(
            onTap: () => widget.onAddToCartPressed(widget.product),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 3),
                  child: ImageIcon(
                    const ResizeImage(
                      AssetImage('assets/images/cart.png'),
                      width: 70,
                      height: 70,
                      allowUpscaling: false,
                    ),
                    color: Theme.of(context).iconTheme.color,
                    size: 20.3,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  margin: const EdgeInsets.only(top: 4.5),
                  child: Text(
                    "ADD TO CART",
                    style: Theme.of(context).textTheme.bodyMedium?.merge(
                          TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
