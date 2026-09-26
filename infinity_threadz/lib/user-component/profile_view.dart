import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:infinity_threadz/common/widgets/circular_progress_indicator.dart';
import 'package:infinity_threadz/common/widgets/navigation_drawer.dart';
import 'package:infinity_threadz/user-component/profile_edit.dart';
import 'package:infinity_threadz/user-component/services/user_service.dart';
import 'package:infinity_threadz/user-component/models/user_model.dart';
import 'package:infinity_threadz/common/widgets/form/button.dart';
import 'package:infinity_threadz/user-component/widgets/profile_numbers.dart';
import 'package:infinity_threadz/user-component/widgets/profile_image.dart';
import 'package:infinity_threadz/common/widgets/appbar.dart';
import 'package:infinity_threadz/common/widgets/demo_notice.dart';

class ProfilePage extends StatefulWidget {
  final int? vehicleId;
  final bool isNavigationFromDrawer;

  const ProfilePage({
    super.key,
    this.vehicleId,
    required this.isNavigationFromDrawer,
  });

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String title = 'Profile';

  static const IconData verified =
      IconData(0xe699, fontFamily: 'MaterialIcons');

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBarWidget(
            title: widget.vehicleId != null ? 'Driver Details' : title,
          ),
          drawer: widget.isNavigationFromDrawer
              ? const CustomNavigationDrawer()
              : null,
          body: buildUserProfile(),
        ),
      ),
    );
  }

  Widget buildUserProfile() {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 2)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          User user = UserService().getUser();

          return ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              ProfileWidget(
                imagePath: user.image,
                onClicked: () {
                  navigateToEdit(user);
                },
              ),
              const SizedBox(height: 15),
              buildName(user),
              const SizedBox(height: 10),
              Center(child: buildQRCodeButton()),
              const SizedBox(height: 20),
              const ProfileNumbersWidget(),
              const SizedBox(height: 40),
              buildAbout(user),
            ],
          );
        } else {
          return const CircularProgressIndicatorWidget();
        }
      },
    );
  }

  Widget buildName(User user) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.headlineMedium?.merge(
                        const TextStyle(
                          fontFamily: 'Galada',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Container(
              margin: const EdgeInsets.only(top: 4),
              child: Icon(
                verified,
                color: user.isVerified ? Colors.blue : Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          user.type,
          style: Theme.of(context).textTheme.titleMedium?.merge(
                const TextStyle(color: Colors.grey),
              ),
        )
      ],
    );
  }

  Widget buildQRCodeButton() {
    return ButtonWidget(
      isPrimary: false,
      text: 'QR Code',
      onClicked: () => showDemoNotice(context, 'QR codes'),
    );
  }

  Widget buildAbout(User user) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: Theme.of(context).textTheme.titleMedium?.merge(
                  const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            user.aboutMeDescription,
          ),
        ],
      ),
    );
  }

  void navigateToEdit(User user) {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditProfilePage(user: user),
          ),
        );
      },
    );
  }
}
