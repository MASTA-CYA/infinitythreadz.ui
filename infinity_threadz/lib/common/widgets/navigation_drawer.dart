import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:infinity_threadz/authentication-component/login_page.dart';
import 'package:infinity_threadz/bug-management-component/report_bug_page.dart';
import 'package:infinity_threadz/cart-component/cart_page.dart';
import 'package:infinity_threadz/orders-component/order_history_page.dart';
import 'package:infinity_threadz/product-catalogue-component/product_catalogue_page.dart';
import 'package:infinity_threadz/user-component/models/user_model.dart';
import 'package:infinity_threadz/user-component/profile_view.dart';
import 'package:infinity_threadz/user-component/services/user_service.dart';
import 'package:infinity_threadz/user-component/widgets/profile_image.dart';
import 'package:infinity_threadz/wallet-component/wallet_page.dart';
import 'package:infinity_threadz/wishlist-component/wishlist_page.dart';

class CustomNavigationDrawer extends StatefulWidget {
  const CustomNavigationDrawer({super.key});

  @override
  State<CustomNavigationDrawer> createState() => _CustomNavigationDrawerState();
}

class _CustomNavigationDrawerState extends State<CustomNavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    bool isLongList = MediaQuery.of(context).size.height >= 685 ? true : false;

    return Drawer(
      child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  buildDrawerHeader(),
                  buildNavigationDestinations(),
                  isLongList ? buildSignOutTile() : const SizedBox.shrink(),
                ],
              ),
            ),
            isLongList ? const SizedBox.shrink() : buildSignOutTile(),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerHeader() {
    User user = UserService().getUser();

    return Row(
      children: [
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              child: Column(
                children: [
                  buildAccountImage(user.image),
                  const SizedBox(
                    height: 8,
                  ),
                  buildAccountUsername(user.name),
                  buildAccountEmail(user.type),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAccountImage(String image) {
    return CircleAvatar(
      radius: 45,
      backgroundImage: ResizeImage(
        profileImageProvider(image),
        width: 1000,
        height: 1000,
      ),
    );
  }

  Widget buildAccountUsername(String name) {
    return Text(
      name,
      style: Theme.of(context).textTheme.headlineSmall?.merge(
            const TextStyle(
              color: Colors.white,
              fontFamily: 'Galada',
              fontWeight: FontWeight.bold,
            ),
          ),
    );
  }

  Widget buildAccountEmail(String type) {
    return Text(
      type,
      style: Theme.of(context).textTheme.titleSmall?.merge(
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
    );
  }

  Widget buildNavigationDestinations() {
    List<Widget> destinations = [
      ListTile(
        leading: const ImageIcon(
          ResizeImage(
            AssetImage('assets/images/hanger.png'),
            width: 70,
            height: 70,
            allowUpscaling: false,
          ),
          size: 25,
        ),
        title: Container(
          margin: const EdgeInsets.only(top: 4.5),
          child: const Text(
            'Catalogue',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Hind Guntur',
            ),
          ),
        ),
        onTap: () => navigateTo(const ProductCataloguePage()),
      ),
      ListTile(
        leading: const ImageIcon(
          ResizeImage(
            AssetImage('assets/images/wallet.png'),
            width: 70,
            height: 70,
            allowUpscaling: false,
          ),
        ),
        title: Container(
          margin: const EdgeInsets.only(top: 4.5),
          child: const Text(
            'Wallet',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Hind Guntur',
            ),
          ),
        ),
        onTap: () => navigateTo(const WalletPage()),
      ),
      ListTile(
        leading: const ImageIcon(
          ResizeImage(
            AssetImage('assets/images/cart-1.png'),
            width: 70,
            height: 70,
            allowUpscaling: false,
          ),
        ),
        title: Container(
          margin: const EdgeInsets.only(top: 4.5),
          child: const Text(
            'Cart',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Hind Guntur',
            ),
          ),
        ),
        onTap: () => navigateTo(const CartPage()),
      ),
      ListTile(
        leading: const Icon(Icons.favorite),
        title: Container(
          margin: const EdgeInsets.only(top: 4.5),
          child: const Text(
            'Wishlist',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Hind Guntur',
            ),
          ),
        ),
        onTap: () => navigateTo(const WishlistPage()),
      ),
      ListTile(
        leading: const ImageIcon(
          ResizeImage(
            AssetImage('assets/images/parcel.png'),
            width: 70,
            height: 70,
            allowUpscaling: false,
          ),
        ),
        title: Container(
          margin: const EdgeInsets.only(top: 4.5),
          child: const Text(
            'Orders',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Hind Guntur',
            ),
          ),
        ),
        onTap: () => navigateTo(const OrderHistoryPage()),
      ),
    ];

    destinations.addAll(
      [
        ListTile(
          leading: const Icon(
            CupertinoIcons.profile_circled,
          ),
          title: Container(
            margin: const EdgeInsets.only(top: 4.5),
            child: const Text(
              'Profile',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Hind Guntur',
              ),
            ),
          ),
          onTap: () => navigateTo(
            const ProfilePage(
              isNavigationFromDrawer: true,
            ),
          ),
        ),
        ListTile(
          leading: const ImageIcon(
            ResizeImage(
              AssetImage('assets/images/bug.png'),
              width: 70,
              height: 70,
              allowUpscaling: false,
            ),
            size: 20,
          ),
          title: Container(
            margin: const EdgeInsets.only(top: 4.5),
            child: const Text(
              'Report Issue',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Hind Guntur',
              ),
            ),
          ),
          onTap: () => navigateTo(const ReportBugPage()),
        ),
      ],
    );

    return Column(
      children: destinations,
    );
  }

  Widget buildSignOutTile() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ListTile(
        leading: const Icon(
          Icons.exit_to_app,
        ),
        title: Container(
          margin: const EdgeInsets.only(top: 4.5),
          child: const Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Hind Guntur',
            ),
          ),
        ),
        onTap: () => signOut(),
      ),
    );
  }

  void signOut() {
    UserService().signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  void navigateTo(Widget widget) {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        Navigator.pop(context);
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
