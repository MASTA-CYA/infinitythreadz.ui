import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:infinity_threadz/cart-component/cart_page.dart';
import 'package:infinity_threadz/common/constants.dart';
import 'package:infinity_threadz/common/widgets/appbar.dart';
import 'package:infinity_threadz/common/widgets/navigation_drawer.dart';
import 'package:infinity_threadz/product-catalogue-component/models/product_model.dart';
import 'package:infinity_threadz/common/widgets/form/filter_dropdown.dart';
import 'package:infinity_threadz/wishlist-component/widgets/wishlist_product_view.dart';
import 'package:infinity_threadz/common/data/demo_data.dart';

class WishlistPage extends StatefulWidget {
  final bool isNavigationFromCatalogue;
  const WishlistPage({
    super.key,
    this.isNavigationFromCatalogue = false,
  });

  @override
  State<StatefulWidget> createState() => _WishlistPage();
}

class _WishlistPage extends State<WishlistPage> {
  final String title = 'Wishlist';

  late List<Product> lsProducts;

  late ScrollController _scrollController;
  final ValueNotifier _canScrollToTop = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() => onWishlistScroll());

    lsProducts = DemoData.wishlist.toList();
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
            child: buildWishlistProducts(),
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

  Widget buildWishlistProducts() {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          buildFilters(),
          buildProducts(),
        ],
      ),
    );
  }

  Widget buildFilters() {
    return Column(
      children: [
        buildSubCategoryFilter(),
        buildSortFilter(),
      ],
    );
  }

  Widget buildSubCategoryFilter() {
    return FilterDropdownWidget(
      label: 'Category',
      filters: mapSubCategoryFilterIcons(
        [
          'Hats',
          'Shirts',
          'Trousers',
          'Shoes',
        ],
      ),
    );
  }

  Map<String, Widget> mapSubCategoryFilterIcons(List<String> filters) {
    Map<String, Widget> filterIcons = {};

    for (String key in filters) {
      switch (key) {
        case 'Hats':
          filterIcons.addAll(
            {
              key: const ImageIcon(
                ResizeImage(AssetImage('assets/images/hat.png'),
                    width: 70, height: 70, allowUpscaling: false),
                size: 20,
              ),
            },
          );
        case 'Shirts':
          filterIcons.addAll(
            {
              key: const ImageIcon(
                ResizeImage(AssetImage('assets/images/shirt.png'),
                    width: 70, height: 70, allowUpscaling: false),
                size: 20,
              ),
            },
          );
        case 'Trousers':
          filterIcons.addAll(
            {
              key: const ImageIcon(
                ResizeImage(AssetImage('assets/images/trousers.png'),
                    width: 70, height: 70, allowUpscaling: false),
                size: 20,
              ),
            },
          );
        case 'Shoes':
          filterIcons.addAll(
            {
              key: const ImageIcon(
                ResizeImage(AssetImage('assets/images/shoes.png'),
                    width: 70, height: 70, allowUpscaling: false),
                size: 20,
              ),
            },
          );
        default:
          filterIcons.addAll(
            {
              'Unknown': const ImageIcon(
                ResizeImage(AssetImage('assets/images/hanger.png'),
                    width: 70, height: 70, allowUpscaling: false),
                size: 20,
              ),
            },
          );
      }
    }

    return filterIcons;
  }

  Widget buildSortFilter() {
    return FilterDropdownWidget(
      label: 'Sort',
      filters: mapSortFilterIcons(
        [
          'Top Rated',
          'New Arrivals',
          'Price: High To Low',
          'Price: Low To High',
        ],
      ),
    );
  }

  Map<String, Widget> mapSortFilterIcons(List<String> filters) {
    Map<String, Widget> filterIcons = {};

    for (String key in filters) {
      switch (key) {
        case 'Top Rated':
          filterIcons.addAll(
            {
              key: const ImageIcon(
                ResizeImage(AssetImage('assets/images/top-rated.png'),
                    width: 70, height: 70, allowUpscaling: false),
                size: 20,
              ),
            },
          );
        case 'New Arrivals':
          filterIcons.addAll(
            {
              key: const ImageIcon(
                ResizeImage(AssetImage('assets/images/new-arrival.png'),
                    width: 70, height: 70, allowUpscaling: false),
                size: 20,
              ),
            },
          );
        case 'Price: High To Low':
          filterIcons.addAll(
            {
              key: const ImageIcon(
                ResizeImage(AssetImage('assets/images/price.png'),
                    width: 70, height: 70, allowUpscaling: false),
                size: 20,
              ),
            },
          );
        case 'Price: Low To High':
          filterIcons.addAll(
            {
              key: const ImageIcon(
                ResizeImage(AssetImage('assets/images/price.png'),
                    width: 70, height: 70, allowUpscaling: false),
                size: 20,
              ),
            },
          );
        default:
          filterIcons.addAll(
            {
              'Unknown': const Icon(
                Icons.filter_alt,
                size: 20,
              ),
            },
          );
      }
    }

    return filterIcons;
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
        return WishlistProductWidget(
          product: lsProducts.elementAt(index),
          onRemoveFromWishlistPressed: (product) =>
              setState(() => lsProducts.remove(product)),
          onAddToCartPressed: (product) => navigateToCart(),
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

  void onWishlistScroll() {
    _canScrollToTop.value = _scrollController.position.extentBefore > 140;
  }

  void scrollToTop() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 400),
    );
  }

  void navigateToCart() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CartPage(
              isNavigationFromCatalogue: true,
            ),
          ),
        );
      },
    );
  }
}
