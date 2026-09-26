import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:infinity_threadz/cart-component/models/cart_product_model.dart';
import 'package:infinity_threadz/cart-component/widgets/cart_button.dart';
import 'package:infinity_threadz/cart-component/widgets/cart_product_view.dart';
import 'package:infinity_threadz/common/constants.dart';
import 'package:infinity_threadz/common/functions.dart';
import 'package:infinity_threadz/common/widgets/appbar.dart';
import 'package:infinity_threadz/common/widgets/navigation_drawer.dart';
import 'package:infinity_threadz/product-catalogue-component/models/product_model.dart';
import 'package:intl/intl.dart';
import 'package:infinity_threadz/common/color_helper.dart' as color_helper;
import 'package:infinity_threadz/common/data/demo_data.dart';
import 'package:infinity_threadz/common/widgets/demo_notice.dart';

class CartPage extends StatefulWidget {
  final bool isNavigationFromCatalogue;
  const CartPage({
    super.key,
    this.isNavigationFromCatalogue = false,
  });

  @override
  State<StatefulWidget> createState() => _CartPage();
}

class _CartPage extends State<CartPage> {
  final String title = 'Cart';

  late NumberFormat formatCurrency;
  final ValueNotifier _total = ValueNotifier(false);

  late List<CartProduct> lsProducts;

  late ScrollController _scrollController;
  final ValueNotifier _canScrollToTop = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    formatCurrency = NumberFormat.simpleCurrency(locale: 'af');

    _scrollController = ScrollController()
      ..addListener(() => onCartPageScroll());

    lsProducts = DemoData.cart();

    calcCartTotal();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double horizontalMargin =
        MediaQuery.of(context).size.width <= DeviceSize.tabletScreenWidth
            ? 10
            : 100;

    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBarWidget(title: title),
          drawer: widget.isNavigationFromCatalogue
              ? null
              : const CustomNavigationDrawer(),
          body: Container(
            margin: EdgeInsets.symmetric(
              horizontal: horizontalMargin,
              vertical: 10,
            ),
            child: buildCartScaffold(),
          ),
          floatingActionButton: ValueListenableBuilder(
            valueListenable: _canScrollToTop,
            builder: (context, canScroll, child) {
              return canScroll
                  ? Container(
                      margin: const EdgeInsets.only(top: 70),
                      child: FloatingActionButton(
                        child: const Icon(Icons.arrow_upward),
                        onPressed: () => scrollToTop(),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
        ),
      ),
    );
  }

  Widget buildCartScaffold() {
    return Column(
      children: [
        buildCartProducts(),
        buildCartTotal(),
        buildBottomButtonBar(),
      ],
    );
  }

  Widget buildCartProducts() {
    return Expanded(
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            GridView.builder(
              primary: true,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 435,
                crossAxisCount: Functions.getCrossAxisCount(
                  MediaQuery.of(context).size.width,
                ),
              ),
              itemCount: lsProducts.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return CartProductWidget(
                  product: lsProducts.elementAt(index).product,
                  onRemoveFromCartPressed: (product) => removeFromCart(product),
                  onSubtotalChanged: (product, subtotal) =>
                      onProductSubtotalChanged(product, subtotal),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCartTotal() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        color: Theme.of(context).brightness == Brightness.dark
            ? color_helper.darken(Colors.grey, 85)
            : Colors.grey.withValues(alpha: 0.2),
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
            ValueListenableBuilder(
              valueListenable: _total,
              builder: (context, total, child) => Container(
                margin: const EdgeInsets.only(top: 4.5),
                child: Text(
                  formatCurrency.format(total),
                  style: const TextStyle(
                    fontFamily: 'Galada',
                    fontSize: 18,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomButtonBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: OverflowBar(
        alignment: MainAxisAlignment.spaceBetween,
        spacing: 8,
        children: [
          CartButtonWidget(
            icon: const Icon(
              Icons.delete_sweep,
              size: 24.5,
            ),
            text: 'Clear Cart',
            color: Colors.red,
            isPrimary: false,
            onClicked: () => clearCart(),
          ),
          CartButtonWidget(
            icon: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: const ImageIcon(
                ResizeImage(
                  AssetImage('assets/images/wallet.png'),
                  width: 70,
                  height: 70,
                  allowUpscaling: false,
                ),
                size: 19,
              ),
            ),
            text: 'Checkout',
            isPrimary: false,
            onClicked: () => showDemoNotice(context, 'Checkout'),
          ),
        ],
      ),
    );
  }

  void onCartPageScroll() {
    _canScrollToTop.value = _scrollController.position.extentBefore > 450;
  }

  void scrollToTop() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 400),
    );
  }

  void onProductSubtotalChanged(Product product, double subtotal) {
    CartProduct cp = lsProducts.firstWhere((p) => p.product == product);
    int index = lsProducts.indexOf(cp);
    cp.subtotal = subtotal;
    lsProducts[index] = cp;

    calcCartTotal();
  }

  void removeFromCart(Product product) {
    setState(() => lsProducts.removeWhere((p) => p.product == product));
    calcCartTotal();
  }

  void clearCart() {
    setState(() => lsProducts.clear());
    calcCartTotal();
  }

  void calcCartTotal() {
    double total = 0;
    for (CartProduct cp in lsProducts) {
      total += cp.subtotal;
    }

    _total.value = total;
  }
}
