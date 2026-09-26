import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:infinity_threadz/bug-management-component/services/bug_report_service.dart';
import 'package:infinity_threadz/common/constants.dart';
import 'package:infinity_threadz/common/widgets/appbar.dart';
import 'package:infinity_threadz/common/widgets/form/button.dart';
import 'package:infinity_threadz/common/widgets/form/textfields.dart';
import 'package:infinity_threadz/common/widgets/navigation_drawer.dart';

class ReportBugPage extends StatefulWidget {
  const ReportBugPage({super.key});

  @override
  State<StatefulWidget> createState() => _ReportBugPage();
}

class _ReportBugPage extends State<ReportBugPage> {
  final String title = 'Issue';

  final _formKey = GlobalKey<FormState>();
  static const List<String> issueTypes = [
    'Performance',
    'Error',
    'Crash',
    'Enhancement',
  ];
  String type = issueTypes.first;
  late TextEditingController descriptionController;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();

    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double horizontalMargin =
        MediaQuery.of(context).size.width <= DeviceSize.tabletScreenWidth
            ? 10
            : 50;

    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBarWidget(title: title),
          drawer: const CustomNavigationDrawer(),
          body: Container(
            margin:
                EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 5),
            child: buildReportForm(),
          ),
        ),
      ),
    );
  }

  Widget buildReportForm() {
    return Form(
      key: _formKey,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 10),
          buildFilterDropdown(),
          const SizedBox(height: 10),
          buildDescription(),
          const SizedBox(height: 20),
          Center(child: buildSubmitButton()),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildFilterDropdown() {
    List<String> list = mapCategoryFilterIcons(issueTypes).keys.toList();

    return DropdownButtonFormField<String>(
      isExpanded: true,
      icon: const Icon(Icons.arrow_downward),
      decoration: InputDecoration(
        labelText: 'Issue/Problem',
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
      initialValue: type,
      onChanged: (String? value) {
        if (value != null) {
          setState(() => type = value);
        }
      },
    );
  }

  Widget getIcon(String filter) {
    Map<String, Widget> filters = mapCategoryFilterIcons(issueTypes);
    return filters.containsKey(filter)
        ? filters[filter] ?? const SizedBox.shrink()
        : filters['Unknown'] ?? const SizedBox.shrink();
  }

  Map<String, Widget> mapCategoryFilterIcons(List<String> filters) {
    Map<String, Widget> filterIcons = {};

    for (String key in filters) {
      switch (key) {
        case 'Performance':
          filterIcons.addAll(
            {
              key: const ImageIcon(
                ResizeImage(AssetImage('assets/images/performance.png'),
                    width: 70,
                    height: 70,
                    allowUpscaling: false,
                    policy: ResizeImagePolicy.exact),
                size: 20,
              ),
            },
          );
        case 'Error':
          filterIcons.addAll(
            {
              key: const ImageIcon(
                ResizeImage(AssetImage('assets/images/error.png'),
                    width: 70,
                    height: 70,
                    allowUpscaling: false,
                    policy: ResizeImagePolicy.exact),
                size: 20,
              ),
            },
          );
        case 'Crash':
          filterIcons.addAll(
            {
              key: const ImageIcon(
                ResizeImage(AssetImage('assets/images/crash-dark.png'),
                    width: 70,
                    height: 70,
                    allowUpscaling: false,
                    policy: ResizeImagePolicy.exact),
                size: 20,
              ),
            },
          );
        case 'Enhancement':
          filterIcons.addAll(
            {
              key: const ImageIcon(
                ResizeImage(AssetImage('assets/images/idea.png'),
                    width: 70,
                    height: 70,
                    allowUpscaling: false,
                    policy: ResizeImagePolicy.exact),
                size: 20,
              ),
            },
          );
        default:
          filterIcons.addAll(
            {
              'Unknown': const ImageIcon(
                ResizeImage(AssetImage('assets/images/bug.png'),
                    width: 70,
                    height: 70,
                    allowUpscaling: false,
                    policy: ResizeImagePolicy.exact),
                size: 20,
              ),
            },
          );
      }
    }

    return filterIcons;
  }

  Widget buildDescription() {
    return TextFieldWidget(
      controller: descriptionController,
      label: 'Description',
      text: '',
      maxLines: 3,
      onChanged: (value) {},
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  Widget buildSubmitButton() {
    return ButtonWidget(
      text: isSubmitting ? 'Submitting...' : 'Submit Request',
      onClicked: () async => submitReport(),
    );
  }

  Future<void> submitReport() async {
    if (isSubmitting || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() => isSubmitting = true);
    final bool wasSuccess = await BugReportService().submit(
      type: type,
      description: descriptionController.text,
    );
    if (!mounted) {
      return;
    }
    setState(() => isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: wasSuccess ? Colors.green : Colors.red,
        content: Text(
          wasSuccess
              ? 'Thanks! Your report has been submitted.'
              : 'Something went wrong. Please try again.',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

    if (wasSuccess) {
      _formKey.currentState?.reset();
      descriptionController.clear();
    }
  }
}
