import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:infinity_threadz/cart-component/cart_page.dart';
import 'package:infinity_threadz/common/constants.dart';
import 'package:infinity_threadz/common/widgets/appbar.dart';
import 'package:infinity_threadz/common/widgets/navigation_drawer.dart';
import 'package:infinity_threadz/product-catalogue-component/models/product_model.dart';
import 'package:infinity_threadz/product-catalogue-component/widgets/catalogue_filter_view.dart';
import 'package:infinity_threadz/product-catalogue-component/widgets/catalogue_product_view.dart';
import 'package:infinity_threadz/wishlist-component/wishlist_page.dart';
import 'package:infinity_threadz/common/data/demo_data.dart';

class ProductCataloguePage extends StatefulWidget {
  final bool isNavigationFromAppbar;

  const ProductCataloguePage({
    super.key,
    this.isNavigationFromAppbar = false,
  });

  @override
  State<StatefulWidget> createState() => _ProductCataloguePage();
}

class _ProductCataloguePage extends State<ProductCataloguePage> {
  final String title = 'Catalogue';

  late List<Product> lsProducts;

  late ScrollController _scrollController;
  final ValueNotifier _canScrollToTop = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() => onCatalogueScroll());

    lsProducts = DemoData.products;
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
          drawer: const CustomNavigationDrawer(),
          body: Container(
            margin: EdgeInsets.symmetric(
              horizontal: horizontalMargin,
              vertical: 10,
            ),
            child: buildProductsCatalogue(),
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

  Widget buildProductsCatalogue() {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          CatalogueFilterWidget(
            isSearchFocused: widget.isNavigationFromAppbar,
          ),
          buildProducts(),
        ],
      ),
    );
  }

  Widget buildProducts() {
    return GridView.builder(
      primary: true,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: 435,
        crossAxisCount: getCrossAxisCount(),
      ),
      itemCount: lsProducts.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return CatalogueProductWidget(
          product: lsProducts.elementAt(index),
          onAddToWishlistPressed: (product) =>
              navigateTo(const WishlistPage(isNavigationFromCatalogue: true)),
          onAddToCartPressed: (product) =>
              navigateTo(const CartPage(isNavigationFromCatalogue: true)),
        );
      },
    );
  }

  int getCrossAxisCount() {
    int axisCount = 0;
    double width = MediaQuery.of(context).size.width;

    if (width > DeviceSize.tabletScreenWidth &&
        width < DeviceSize.laptopScreenWidth) {
      axisCount = 2;
    } else if (width >= DeviceSize.laptopScreenWidth) {
      axisCount = 3;
    } else {
      axisCount = 1;
    }

    return axisCount;
  }

  void scrollToTop() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 400),
    );
  }

  void onCatalogueScroll() {
    _canScrollToTop.value = _scrollController.position.extentBefore > 400;
  }

  void navigateTo(Widget widget) {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => widget,
          ),
        );
      },
    );
  }
}
