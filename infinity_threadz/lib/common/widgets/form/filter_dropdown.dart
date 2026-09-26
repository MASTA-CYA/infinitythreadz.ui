import 'package:flutter/material.dart';
import 'package:infinity_threadz/common/color_helper.dart' as color_helper;

class FilterDropdownWidget extends StatefulWidget {
  final String label;
  final Map<String, Widget> filters;
  const FilterDropdownWidget({
    super.key,
    required this.label,
    required this.filters,
  });

  @override
  State<StatefulWidget> createState() => _FilterDropdownWidget();
}

class _FilterDropdownWidget extends State<FilterDropdownWidget>
    with TickerProviderStateMixin {
  // filter
  late AnimationController _controller;
  late Animation _animation;
  final ValueNotifier _isFilterOpen = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

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
      (_) {
        _animation = ColorTween(
          begin: Theme.of(context).iconTheme.color,
          end: Theme.of(context).primaryColor,
        ).animate(_controller)
          ..addListener(
            () => {},
          );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _animation = ColorTween(
      begin: Theme.of(context).iconTheme.color,
      end: Theme.of(context).primaryColor,
    ).animate(_controller)
      ..addListener(
        () => {},
      );

    return buildFilter();
  }

  Widget buildFilter() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: ValueListenableBuilder(
        valueListenable: _isFilterOpen,
        builder: (context, filterState, child) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              children: [
                _isFilterOpen.value
                    ? Expanded(child: buildFilterDropdown())
                    : Expanded(
                        child: Text(
                          widget.label,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                IconButton(
                  icon: ImageIcon(
                    const ResizeImage(AssetImage('assets/images/filter.png'),
                        height: 87,
                        width: 87,
                        allowUpscaling: false,
                        policy: ResizeImagePolicy.exact),
                    color: _animation.value,
                  ),
                  onPressed: () async {
                    filterState
                        ? await _controller.reverse()
                        : await _controller.forward();
                    _isFilterOpen.value = !filterState;
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildFilterDropdown() {
    List<String> list = widget.filters.keys.toList();

    return DropdownButtonFormField<String>(
      isDense: true,
      isExpanded: true,
      icon: const Icon(Icons.arrow_downward),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        labelText: widget.label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1),
        ),
      ),
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getIcon(value),
              const SizedBox(width: 10),
              Container(
                margin: const EdgeInsets.only(top: 3),
                child: Text(value),
              ),
            ],
          ),
        );
      }).toList(),
      initialValue: list.first,
      onChanged: (String? value) {
        // This is called when the user selects an item.
      },
    );
  }

  Widget getIcon(String filter) {
    return widget.filters.containsKey(filter)
        ? widget.filters[filter] ?? const SizedBox.shrink()
        : widget.filters['Unknown'] ?? const SizedBox.shrink();
  }
}
