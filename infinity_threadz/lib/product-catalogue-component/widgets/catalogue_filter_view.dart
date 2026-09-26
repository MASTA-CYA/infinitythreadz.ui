import 'package:flutter/material.dart';
import 'package:infinity_threadz/product-catalogue-component/models/catalogue_filter_model.dart';
import 'package:infinity_threadz/product-catalogue-component/widgets/catalogue_category_view.dart';
import 'package:infinity_threadz/common/widgets/form/filter_dropdown.dart';
import 'package:infinity_threadz/product-catalogue-component/widgets/search_bar.dart';

class CatalogueFilterWidget extends StatefulWidget {
  final bool? isSearchFocused;

  const CatalogueFilterWidget({
    super.key,
    this.isSearchFocused = false,
  });

  @override
  State<CatalogueFilterWidget> createState() => _CatalogueFilterWidget();
}

class _CatalogueFilterWidget extends State<CatalogueFilterWidget> {
  final ValueNotifier _isSearchOpen = ValueNotifier(false);
  late List<CatalogueFilter> lsCategories;

  @override
  void initState() {
    super.initState();

    lsCategories = [
      CatalogueFilter(text: 'Men', isSelected: true),
      CatalogueFilter(text: 'Women'),
      CatalogueFilter(text: 'Beauty'),
      CatalogueFilter(text: 'Kids'),
      CatalogueFilter(text: 'Accessories'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildCategoryMenu(),
        buildSearchBar(),
        buildFilters(),
      ],
    );
  }

  Widget buildCategoryMenu() {
    double maxHeight = MediaQuery.of(context).size.height * 0.06;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: lsCategories.length,
          itemBuilder: (context, index) {
            return CatalogueCategoryWidget(
              category: lsCategories.elementAt(index),
              onCategorySelected: (category) => onCategorySelected(category),
            );
          },
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return SearchBarWidget(
      isSearchFocused: widget.isSearchFocused!,
      onFocusStatusChanged: (hasFocus) =>
          onSearchBarFocusChanged(hasFocus),
    );
  }

  Widget buildFilters() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: ValueListenableBuilder(
        valueListenable: _isSearchOpen,
        builder: (context, searchState, child) {
          return searchState
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    buildSubCategoryFilter(),
                    buildSortFilter(),
                  ],
                );
        },
      ),
    );
  }

  Widget buildSubCategoryFilter() {
    return FilterDropdownWidget(
      label: 'Category',
      filters: mapSubCategoryFilterIcons(
        [
          'Hats',
          'Shirts',
          'Trousers',
          'Shoes',
        ],
      ),
    );
  }

  Map<String, Widget> mapSubCategoryFilterIcons(List<String> filters) {
    Map<String, Widget> filterIcons = {};

    for (String key in filters) {
      switch (key) {
        case 'Hats':
          filterIcons.addAll(
            {
              key: const ImageIcon(
                ResizeImage(AssetImage('assets/images/hat.png'),
                    width: 70, height: 70, allowUpscaling: false),
                size: 20,
              ),
            },
          );
        case 'Shirts':
          filterIcons.addAll(
            {
              key: const ImageIcon(
                ResizeImage(AssetImage('assets/images/shirt.png'),
                    width: 70, height: 70, allowUpscaling: false),
                size: 20,
              ),
            },
          );
        case 'Trousers':
          filterIcons.addAll(
            {
              key: const ImageIcon(
                ResizeImage(AssetImage('assets/images/trousers.png'),
                    width: 70, height: 70, allowUpscaling: false),
                size: 20,
              ),
            },
          );
        case 'Shoes':
          filterIcons.addAll(
            {
              key: const ImageIcon(
                ResizeImage(AssetImage('assets/images/shoes.png'),
                    width: 70, height: 70, allowUpscaling: false),
                size: 20,
              ),
            },
          );
        default:
          filterIcons.addAll(
            {
              'Unknown': const ImageIcon(
                ResizeImage(AssetImage('assets/images/hanger.png'),
                    width: 70, height: 70, allowUpscaling: false),
                size: 20,
              ),
            },
          );
      }
    }

    return filterIcons;
  }

  Widget buildSortFilter() {
    return FilterDropdownWidget(
      label: 'Sort',
      filters: mapSortFilterIcons(
        [
          'Top Rated',
          'New Arrivals',
          'Price: High To Low',
          'Price: Low To High',
        ],
      ),
    );
  }

  Map<String, Widget> mapSortFilterIcons(List<String> filters) {
    Map<String, Widget> filterIcons = {};

    for (String key in filters) {
      switch (key) {
        case 'Top Rated':
          filterIcons.addAll(
            {
              key: const ImageIcon(
                ResizeImage(AssetImage('assets/images/top-rated.png'),
                    width: 70, height: 70, allowUpscaling: false),
                size: 20,
              ),
            },
          );
        case 'New Arrivals':
          filterIcons.addAll(
            {
              key: const ImageIcon(
                ResizeImage(AssetImage('assets/images/new-arrival.png'),
                    width: 70, height: 70, allowUpscaling: false),
                size: 20,
              ),
            },
          );
        case 'Price: High To Low':
          filterIcons.addAll(
            {
              key: const ImageIcon(
                ResizeImage(AssetImage('assets/images/price.png'),
                    width: 70, height: 70, allowUpscaling: false),
                size: 20,
              ),
            },
          );
        case 'Price: Low To High':
          filterIcons.addAll(
            {
              key: const ImageIcon(
                ResizeImage(AssetImage('assets/images/price.png'),
                    width: 70, height: 70, allowUpscaling: false),
                size: 20,
              ),
            },
          );
        default:
          filterIcons.addAll(
            {
              'Unknown': const Icon(
                Icons.filter_alt,
                size: 20,
              ),
            },
          );
      }
    }

    return filterIcons;
  }

  void onCategorySelected(String category) {
    List<CatalogueFilter> categories = [];
    for (CatalogueFilter filter in lsCategories) {
      filter.isSelected = (filter.text == category);
      categories.add(filter);
    }
    lsCategories = categories;
    setState(() {});
  }

  void onSearchBarFocusChanged(bool hasFocus) {
    _isSearchOpen.value = !_isSearchOpen.value;
  }
}
