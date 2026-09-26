import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:infinity_threadz/common/constants.dart';
import 'package:infinity_threadz/common/widgets/appbar.dart';
import 'package:infinity_threadz/orders-component/models/order_items_model.dart';
import 'package:infinity_threadz/orders-component/models/order_model.dart';
import 'package:infinity_threadz/orders-component/order_tracking_page.dart';
import 'package:infinity_threadz/orders-component/widgets/order_button.dart';
import 'package:infinity_threadz/orders-component/widgets/order_details_header.dart';
import 'package:intl/intl.dart';
import 'package:infinity_threadz/common/data/demo_data.dart';
import 'package:infinity_threadz/common/widgets/demo_notice.dart';

class OrderDetailsPage extends StatefulWidget {
  final Order order;
  const OrderDetailsPage({
    super.key,
    required this.order,
  });

  @override
  State<StatefulWidget> createState() => _OrderDetailsPage();
}

class _OrderDetailsPage extends State<OrderDetailsPage> {
  final String title = 'Details';

  late NumberFormat formatCurrency;

  late ScrollController _scrollController;
  final ValueNotifier _canScrollToTop = ValueNotifier(false);

  late Map<String, ValueNotifier<bool?>> orderSections;
  late List<OrderItem> lsOrderItems;

  @override
  void initState() {
    super.initState();

    formatCurrency = NumberFormat.simpleCurrency(locale: 'af');
    _scrollController = ScrollController()
      ..addListener(() => onOrderPageScroll());

    orderSections = {
      'Order': ValueNotifier<bool>(true),
      'Payment': ValueNotifier<bool>(true),
      'Items': ValueNotifier<bool>(true),
      'Delivery': ValueNotifier<bool>(true),
    };

    lsOrderItems = DemoData.orderItems;
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
          body: Container(
            margin: EdgeInsets.symmetric(
              horizontal: horizontalMargin,
              vertical: 10,
            ),
            child: buildOrderScaffold(),
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

  Widget buildOrderScaffold() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                buildOrderHeader(),
                buildPaymentHeader(),
                buildOrderItemsHeader(),
                buildDeliveryHeader(),
              ],
            ),
          ),
        ),
        buildBottomButtonBar(),
      ],
    );
  }

  Widget buildOrderHeader() {
    return Column(
      children: [
        OrderDetailsHeaderWidget(
          title: 'Order',
          onSectionExpanded: (title, isExpanded) =>
              onSectionExpanded(title, isExpanded),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: ValueListenableBuilder(
            valueListenable: orderSections['Order']!,
            builder: (context, isExpanded, child) {
              return isExpanded!
                  ? buildOrderDetails()
                  : const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget buildOrderDetails() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Reference Number: '),
              Text(widget.order.reference),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              const Text('Date: '),
              Text('${widget.order.date} ${widget.order.time}'),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              const Text('Status: '),
              Text(
                widget.order.status,
                style: Theme.of(context).textTheme.bodyMedium?.merge(
                      TextStyle(
                        color: getOrderStatusColor(widget.order.status),
                      ),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPaymentHeader() {
    return Column(
      children: [
        OrderDetailsHeaderWidget(
          title: 'Payment',
          onSectionExpanded: (title, isExpanded) =>
              onSectionExpanded(title, isExpanded),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: ValueListenableBuilder(
            valueListenable: orderSections['Payment']!,
            builder: (context, isExpanded, child) {
              return isExpanded!
                  ? buildPaymentDetails()
                  : const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget buildPaymentDetails() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Column(
        children: [
          const Row(
            children: [
              Text('Method: '),
              Text('Instant EFT'),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          const Row(
            children: [
              Text('Channel: '),
              Text('OZOW'),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              const Text('Total: '),
              Text(
                formatCurrency.format(
                  lsOrderItems.fold<double>(
                    0,
                    (sum, item) => sum + item.subtotal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              const Text('Outcome: '),
              Text(
                'Successful',
                style: Theme.of(context).textTheme.bodyMedium?.merge(
                      const TextStyle(color: Colors.green),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildOrderItemsHeader() {
    return Column(
      children: [
        OrderDetailsHeaderWidget(
          title: 'Items',
          onSectionExpanded: (title, isExpanded) =>
              onSectionExpanded(title, isExpanded),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: ValueListenableBuilder(
            valueListenable: orderSections['Items']!,
            builder: (context, isExpanded, child) {
              return isExpanded!
                  ? buildOrderItemsDetails()
                  : const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget buildOrderItemsDetails() {
    double total = lsOrderItems
        .map((element) => element.subtotal)
        .toList()
        .fold(0, (current, next) => current + next);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Column(
        children: [
          Column(
            children: lsOrderItems
                .map(
                  (item) => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${item.quantity} X ${item.name}'),
                          Text(formatCurrency.format(item.subtotal)),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
          Divider(indent: MediaQuery.of(context).size.width / 1.45),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(formatCurrency.format(total)),
            ],
          )
        ],
      ),
    );
  }

  Widget buildDeliveryHeader() {
    return Column(
      children: [
        OrderDetailsHeaderWidget(
          title: 'Delivery',
          onSectionExpanded: (title, isExpanded) =>
              onSectionExpanded(title, isExpanded),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: ValueListenableBuilder(
            valueListenable: orderSections['Delivery']!,
            builder: (context, isExpanded, child) {
              return isExpanded!
                  ? buildDeliveryDetails()
                  : const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget buildDeliveryDetails() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('Estimated Date: '),
              Text('2023/10/27'),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Instructions:'),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Call when at the gate'),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Address: '),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '17 Sharp Needle Road',
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Soft Fabric Valley',
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'United States of Fashion',
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '6024',
                  ),
                ),
              ],
            ),
          ),
        ],
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
          OrderButtonWidget(
            icon: const Icon(
              Icons.file_download_outlined,
              size: 24.5,
            ),
            text: 'Download',
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
            isPrimary: false,
            onClicked: () => showDemoNotice(context, 'Invoice downloads'),
          ),
          OrderButtonWidget(
            icon: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: const ImageIcon(
                ResizeImage(
                  AssetImage('assets/images/tracking.png'),
                  width: 70,
                  height: 70,
                  allowUpscaling: false,
                ),
                size: 22,
              ),
            ),
            text: 'Track',
            isPrimary: false,
            onClicked: () async => navigateToTracking(),
          ),
        ],
      ),
    );
  }

  void scrollToTop() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 400),
    );
  }

  void onSectionExpanded(String title, bool isExpanded) {
    orderSections.update(title, (value) {
      value.value = isExpanded;
      return value;
    }, ifAbsent: () => ValueNotifier(isExpanded));
  }

  Color? getOrderStatusColor(String status) {
    switch (status) {
      case 'Fulfilled':
        return Colors.green;
      case 'In Progress':
        return Colors.blue;
      case 'Cancelled':
        return Colors.red;
      default:
        return Theme.of(context).textTheme.bodyMedium?.color;
    }
  }

  void onOrderPageScroll() {
    _canScrollToTop.value = _scrollController.position.extentBefore > 150;
  }

  void navigateToTracking() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OrderTrackingPage(),
          ),
        );
      },
    );
  }
}
