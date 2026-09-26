
import 'package:flutter/material.dart';
import 'package:infinity_threadz/common/widgets/circular_progress_indicator.dart';

class AppLoadWidget extends StatefulWidget {
  const AppLoadWidget({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AppLoadWidget();
}

class _AppLoadWidget extends State<AppLoadWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              key: UniqueKey(),
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ResizeImage(
                    AssetImage(
                      isDark
                          ? 'assets/images/logo-dark.png'
                          : 'assets/images/logo-light.png',
                    ),
                    width: 1000,
                    height: 1000,
                  ),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          const Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: CircularProgressIndicatorWidget(
                useIcon: true,
              ),
            ),

          ),
        ],
      ),
    );
  }
}
