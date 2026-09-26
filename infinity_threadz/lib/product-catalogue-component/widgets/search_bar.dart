import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinity_threadz/common/color_helper.dart' as color_helper;

class SearchBarWidget extends StatefulWidget {
  final bool isSearchFocused;
  final void Function(bool hasFocus)? onFocusStatusChanged;

  const SearchBarWidget({
    super.key,
    required this.isSearchFocused,
    this.onFocusStatusChanged,
  });

  @override
  State<StatefulWidget> createState() => _SearchBarWidget();
}

class _SearchBarWidget extends State<SearchBarWidget>
    with SingleTickerProviderStateMixin {
  late final TextEditingController controller;
  late FocusNode searchFocusNode;

  // filter
  late AnimationController _controller;
  late Animation _animation;
  final ValueNotifier _isSearchOpen = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
    searchFocusNode = FocusNode()
      ..addListener(
        () => onFocusedChanged(),
      );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animation = ColorTween(
      begin: Colors.black,
      end: color_helper.HexColor.fromHex('#0191DA'),
    ).animate(_controller)
      ..addListener(
        () => {},
      );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        _animation = ColorTween(
          begin: Theme.of(context).iconTheme.color,
          end: Theme.of(context).primaryColor,
        ).animate(_controller)
          ..addListener(
            () => {},
          );

        if (widget.isSearchFocused) {
          await _controller.forward();
          _isSearchOpen.value = widget.isSearchFocused;
          searchFocusNode.requestFocus();
        }
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animation = ColorTween(
      begin: Theme.of(context).iconTheme.color,
      end: Theme.of(context).primaryColor,
    ).animate(_controller);

    return buildSearchWithToggle();
  }

  Widget buildSearchWithToggle() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: ValueListenableBuilder(
        valueListenable: _isSearchOpen,
        builder: (context, searchState, child) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: searchState
                ? buildTextField()
                : Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Search',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          CupertinoIcons.search,
                          color: _animation.value,
                        ),
                        onPressed: () async {
                          searchState
                              ? await _controller.reverse()
                              : await _controller.forward();
                          _isSearchOpen.value = !searchState;
                        },
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget buildTextField() {
    return TextField(
      controller: controller,
      focusNode: searchFocusNode,
      showCursor: false,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        labelText: 'Search',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 5,
        ),
        prefixIcon: Icon(
          CupertinoIcons.search,
          color: Theme.of(context).primaryColor,
        ),
        suffixIcon: buildSuffixIcon(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1),
        ),
      ),
      onChanged: (text) => setState(() {}),
    );
  }

  Widget? buildSuffixIcon() {
    return controller.value.text.isNotEmpty
        ? IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.red,
            ),
            onPressed: () {
              controller.clear();
              setState(
                () {},
              );
            },
          )
        : IconButton(
            icon: Icon(
              Icons.arrow_upward,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () async => onSearchStateChanged(),
          );
  }

  void onSearchStateChanged() async {
    searchFocusNode.unfocus();
    await _controller.reverse();
    _isSearchOpen.value = !_isSearchOpen.value;
  }

  void onFocusedChanged() {
    if (widget.onFocusStatusChanged != null) {
      widget.onFocusStatusChanged!(searchFocusNode.hasFocus);
    }
    setState(() {});
  }
}
