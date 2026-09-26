import 'package:flutter/material.dart';
import 'package:infinity_threadz/product-catalogue-component/models/product_model.dart';
import 'package:infinity_threadz/product-catalogue-component/widgets/read_more_text.dart';
import 'package:intl/intl.dart';

class CatalogueProductWidget extends StatefulWidget {
  final Product product;
  final Function(Product product) onAddToWishlistPressed;
  final Function(Product product) onAddToCartPressed;
  const CatalogueProductWidget({
    super.key,
    required this.product,
    required this.onAddToWishlistPressed,
    required this.onAddToCartPressed,
  });

  @override
  State<StatefulWidget> createState() => _CatalogueProductWidget();
}

class _CatalogueProductWidget extends State<CatalogueProductWidget> {
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
    final formatCurrency = NumberFormat.simpleCurrency(locale: 'af');

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
        alignment: MainAxisAlignment.spaceBetween,
        spacing: 8,
        children: [
          InkWell(
            onTap: () => widget.onAddToWishlistPressed(widget.product),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                ),
                const SizedBox(width: 8),
                Container(
                  margin: const EdgeInsets.only(top: 4.5),
                  child: Text(
                    "ADD TO WISHLIST",
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
