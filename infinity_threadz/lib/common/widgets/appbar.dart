import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinity_threadz/cart-component/cart_page.dart';
import 'package:infinity_threadz/common/constants.dart';
import 'package:infinity_threadz/common/themes.dart';
import 'package:infinity_threadz/common/widgets/scrolling_text.dart';
import 'package:infinity_threadz/product-catalogue-component/product_catalogue_page.dart';
import 'package:infinity_threadz/user-component/services/user_service.dart';
import 'package:infinity_threadz/wishlist-component/wishlist_page.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Widget? actions;
  const AppBarWidget({super.key, required this.title, this.actions});

  @override
  State<StatefulWidget> createState() => _AppBarWidget();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarWidget extends State<AppBarWidget> {
  static const double iconSpacing = 10;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: buildTitle(),
      elevation: 1,
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildThemeSwitcher(),
              const SizedBox(width: iconSpacing),
              buildSearchIcon(),
              const SizedBox(width: iconSpacing),
              buildWishlistIcon(),
              const SizedBox(width: iconSpacing),
              buildCartIcon(),
              if (widget.actions != null) ...{
                const SizedBox(width: iconSpacing),
                widget.actions as Widget,
              }
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTitle() {
    TextStyle? style = Theme.of(context)
        .textTheme
        .displaySmall
        ?.merge(Theme.of(context).appBarTheme.titleTextStyle);

    bool isSmallDevice =
        MediaQuery.of(context).size.width < DeviceSize.smallDeviceWidth;
    bool isLargeText = widget.title.length > 10;
    if (isSmallDevice || isLargeText) {
      return SizedBox(
        height: kToolbarHeight,
        child: Center(
          child: ScrollingTextWidget(
            text: widget.title,
            textStyle: style,
          ),
        ),
      );
    } else {
      return Center(
        child: Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            widget.title,
            style: style,
          ),
        ),
      );
    }
  }

  Widget buildThemeSwitcher() {
    final ThemeData currentTheme;
    final IconData icon;

    currentTheme = Theme.of(context).brightness == Brightness.dark
        ? AppThemes.lightTheme
        : AppThemes.darkTheme;
    icon = Theme.of(context).brightness == Brightness.dark
        ? CupertinoIcons.sun_max
        : CupertinoIcons.moon_stars;

    return ThemeSwitcher(
      builder: (context) {
        return GestureDetector(
          child: Icon(icon),
          onTap: () async {
            ThemeSwitcher.of(context).changeTheme(theme: currentTheme);
            UserService()
                .changeTheme(currentTheme.brightness == Brightness.dark);
          },
        );
      },
    );
  }

  Widget buildSearchIcon() {
    return GestureDetector(
      child: const Icon(Icons.search),
      onTap: () => navigateTo(const ProductCataloguePage(
        isNavigationFromAppbar: true,
      )),
    );
  }

  Widget buildWishlistIcon() {
    return GestureDetector(
      child: const Icon(
        Icons.favorite_border,
      ),
      onTap: () => navigateTo(const WishlistPage()),
    );
  }

  Widget buildCartIcon() {
    return GestureDetector(
      child: const ImageIcon(
        ResizeImage(
          AssetImage('assets/images/cart-2.png'),
          width: 70,
          height: 70,
          allowUpscaling: false,
        ),
        size: 23,
      ),
      onTap: () => navigateTo(const CartPage()),
    );
  }

  void navigateTo(Widget widget) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
  }
}
