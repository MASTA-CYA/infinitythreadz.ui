import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:infinity_threadz/authentication-component/widgets/login_text_field.dart';
import 'package:infinity_threadz/common/constants.dart';
import 'package:infinity_threadz/common/themes.dart';
import 'package:infinity_threadz/common/widgets/form/button.dart';
import 'package:infinity_threadz/common/widgets/keyboard_visibility_builder.dart';
import 'package:infinity_threadz/product-catalogue-component/product_catalogue_page.dart';
import 'package:infinity_threadz/user-component/services/user_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> with TickerProviderStateMixin {
  // form
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  late FocusNode usernameFocusNode;
  late FocusNode passwordFocusNode;

  @override
  void initState() {
    super.initState();

    usernameFocusNode = FocusNode();
    passwordFocusNode = FocusNode();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double horizontalMargin =
        MediaQuery.of(context).size.width <= DeviceSize.tabletScreenWidth
            ? 10
            : 100;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) => Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                KeyboardVisibilityListener(
                  builder: (context, child, isKeyboardVisible) {
                    return Expanded(
                      child: Stack(
                        children: [
                          AnimatedSwitcher(
                            transitionBuilder: (child, animation) =>
                                ScaleTransition(
                              scale: animation,
                              child: child,
                            ),
                            duration: const Duration(milliseconds: 600),
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
                                  fit: isKeyboardVisible
                                      ? BoxFit.fitHeight
                                      : BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: buildThemeSwitcher(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                KeyboardVisibilityListener(
                  builder: (context, child, isKeyboardVisible) {
                    if (!isKeyboardVisible) {
                      return Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: SlideTransition(
                                position: _offsetAnimation,
                                child: buildLoginPage(horizontalMargin),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return SlideTransition(
                        position: _offsetAnimation,
                        child: buildLoginPage(horizontalMargin),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          resizeToAvoidBottomInset: true,
        ),
      ),
    );
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
        return IconButton(
          icon: Icon(icon),
          onPressed: () async {
            ThemeSwitcher.of(context).changeTheme(theme: currentTheme);
            UserService()
                .changeTheme(currentTheme.brightness == Brightness.dark);
          },
        );
      },
    );
  }

  Widget buildLoginPage(double horizontalMargin) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(
              horizontalMargin,
              16,
              horizontalMargin,
              8,
            ),
            child: LoginTextFieldWidget(
              focusNode: usernameFocusNode,
              controller: usernameController,
              action: TextInputAction.next,
              label: 'Username',
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Please enter a username'
                  : null,
              onTextChanged: (value) {},
              onSubmitted: (value) => passwordFocusNode.requestFocus(),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(
              horizontalMargin,
              8,
              horizontalMargin,
              14,
            ),
            child: LoginTextFieldWidget(
              focusNode: passwordFocusNode,
              controller: passwordController,
              action: TextInputAction.done,
              label: 'Password',
              isPassword: true,
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Please enter a password'
                  : null,
              onTextChanged: (value) {},
              onSubmitted: (value) => signIn(),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ThemeSwitcher(
            builder: (context) {
              return ButtonWidget(
                text: 'Sign In',
                onClicked: () async => signIn(),
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Demo mode: sign in with any username and password.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Future signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      passwordFocusNode.unfocus();

      // Demo build: there is no auth backend, so any credentials sign in
      // as the demo shopper.
      UserService().signIn();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Successfully Signed In',
            style: Theme.of(context).textTheme.bodyMedium?.merge(
                  const TextStyle(
                    fontFamily: 'Galada',
                    color: Colors.white,
                  ),
                ),
          ),
        ),
      );
      _formKey.currentState?.reset();
      usernameController.clear();
      passwordController.clear();

      navigateToHomePage();
    }
  }

  void navigateToHomePage() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ProductCataloguePage(),
          ),
        );
      },
    );
  }
}
