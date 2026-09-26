import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:infinity_threadz/common/constants.dart';
import 'package:infinity_threadz/common/widgets/appbar.dart';
import 'package:infinity_threadz/orders-component/models/tracking_step_model.dart';
import 'package:infinity_threadz/orders-component/widgets/tracking_step.dart';
import 'package:infinity_threadz/common/widgets/demo_notice.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});

  @override
  State<StatefulWidget> createState() => _OrderTrackingPage();
}

class _OrderTrackingPage extends State<OrderTrackingPage> {
  final String title = 'Tracking';

  late ScrollController _scrollController;
  final ValueNotifier _canScrollToTop = ValueNotifier(false);

  late List<TrackingStep> lsSteps;
  late Map<String, bool> statuses;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() => onTrackingPageScroll());

    lsSteps = const [
      TrackingStep(
        title: 'Order Placed',
        body: 'Order accepted by vendor.',
        status: 'Completed',
      ),
      TrackingStep(
        title: 'Payment',
        body: 'Payment received and verified.',
        status: 'Completed',
      ),
      TrackingStep(
        title: 'Dispatched',
        body: 'Order dispatched for delivery.',
        status: 'Pending',
      ),
      TrackingStep(
        title: 'Delivery',
        body: 'Order expected on 2023/10/27 before 17:00.',
        status: 'Blocked',
      ),
    ];
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
            child: buildOrderSteps(),
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

  Widget buildOrderSteps() {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            buildDownloadHeader(),
            Column(
              children: lsSteps
                  .map(
                    (step) => TrackingStepWidget(
                        title: step.title,
                        body: step.body,
                        color: getStatusColor(step.status),
                        isLastChild:
                            (lsSteps.indexOf(step) == lsSteps.length - 1),
                        isConnectorLeft: lsSteps.indexOf(step).isOdd,
                        completionTime: lsSteps.indexOf(step) < 2
                            ? '2023/10/17 at 22:43.'
                            : ''),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void onTrackingPageScroll() {
    _canScrollToTop.value = _scrollController.position.extentBefore > 200;
  }

  void scrollToTop() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 400),
    );
  }

  Color? getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Pending':
        return Theme.of(context).primaryColor;
      default:
        return Theme.of(context).textTheme.bodyMedium?.color;
    }
  }

  Widget buildDownloadHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: IconButton(
            icon: const Icon(
              Icons.file_download_outlined,
              size: 25,
            ),
            onPressed: () => showDemoNotice(context, 'Tracking downloads'),
          ),
        ),
      ],
    );
  }
}
