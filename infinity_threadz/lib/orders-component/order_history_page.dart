import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:infinity_threadz/common/constants.dart';
import 'package:infinity_threadz/common/widgets/appbar.dart';
import 'package:infinity_threadz/common/widgets/form/filter_dropdown.dart';
import 'package:infinity_threadz/common/widgets/navigation_drawer.dart';
import 'package:infinity_threadz/orders-component/models/order_model.dart';
import 'package:infinity_threadz/orders-component/order_details_page.dart';
import 'package:infinity_threadz/common/data/demo_data.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<StatefulWidget> createState() => _OrdersPage();
}

class _OrdersPage extends State<OrderHistoryPage> {
  final String title = 'Orders';

  late ScrollController _scrollController;
  final ValueNotifier _canScrollToTop = ValueNotifier(false);

  late List<Order> lsOrders;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() => onCatalogueScroll());

    lsOrders = DemoData.orders;
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
            child: buildOrderHistory(),
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

  Widget buildOrderHistory() {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          buildStatusFilter(),
          buildOrders(),
        ],
      ),
    );
  }

  Widget buildStatusFilter() {
    return FilterDropdownWidget(
      label: 'Status',
      filters: mapStatusFilterIcons(
        [
          'Fulfilled',
          'In Progress',
          'Cancelled',
        ],
      ),
    );
  }

  Map<String, Widget> mapStatusFilterIcons(List<String> filters) {
    Map<String, Widget> filterIcons = {};

    for (String key in filters) {
      switch (key) {
        case 'Fulfilled':
          filterIcons.addAll(
            {
              key: const Icon(
                Icons.check_sharp,
                size: 20,
              ),
            },
          );
        case 'In Progress':
          filterIcons.addAll(
            {
              key: const ImageIcon(
                ResizeImage(AssetImage('assets/images/processing-time.png'),
                    width: 70, height: 70, allowUpscaling: false),
                size: 20,
              ),
            },
          );
        case 'Cancelled':
          filterIcons.addAll(
            {
              key: const Icon(
                Icons.close,
                size: 20,
              ),
            },
          );
        default:
          filterIcons.addAll(
            {
              'Unknown': const ImageIcon(
                ResizeImage(AssetImage('assets/images/parcel.png'),
                    width: 70, height: 70, allowUpscaling: false),
                size: 20,
              ),
            },
          );
      }
    }

    return filterIcons;
  }

  Widget buildOrders() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: lsOrders.length,
      itemBuilder: (context, index) {
        Order order = lsOrders.elementAt(index);

        return ListTile(
          leading: buildOrderIcon(order.status),
          title: Text(
            order.reference,
            style: Theme.of(context).textTheme.titleLarge?.merge(
                  const TextStyle(fontWeight: FontWeight.bold),
                ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 3),
                    child: Text(
                      order.date,
                      style: Theme.of(context).textTheme.bodyLarge?.merge(
                            const TextStyle(color: Colors.grey),
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.watch_later_outlined,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 3),
                    child: Text(
                      order.time,
                      style: Theme.of(context).textTheme.titleMedium?.merge(
                            const TextStyle(color: Colors.grey),
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: GestureDetector(
            child: const ImageIcon(
              ResizeImage(
                AssetImage('assets/images/right.png'),
                width: 70,
                height: 70,
                allowUpscaling: false,
              ),
            ),
            onTap: () => navigateToOrderDetails(order),
          ),
        );
      },
    );
  }

  Widget buildOrderIcon(String status) {
    switch (status) {
      case 'Fulfilled':
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.green,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(5),
            child: const Icon(
              Icons.check_sharp,
              color: Colors.green,
            ),
          ),
        );
      case 'In Progress':
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.blue,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(5),
            child: const ImageIcon(
              ResizeImage(AssetImage('assets/images/processing-time.png'),
                  width: 70, height: 70, allowUpscaling: false),
              color: Colors.blue,
            ),
          ),
        );
      default:
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.red,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(5),
            child: const Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
        );
    }
  }

  void scrollToTop() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 400),
    );
  }

  void onCatalogueScroll() {
    _canScrollToTop.value = _scrollController.position.extentBefore > 200;
  }

  void navigateToOrderDetails(Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsPage(order: order),
      ),
    );
  }
}
