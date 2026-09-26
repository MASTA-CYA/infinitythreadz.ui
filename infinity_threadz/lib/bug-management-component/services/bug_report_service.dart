import 'package:infinity_threadz/bug-management-component/models/bug_report_model.dart';

/// Collects issue reports submitted from the app.
///
/// Demo build: reports are kept in memory for the session. Swap
/// [submit] for an HTTP call when a support backend is available.
class BugReportService {
  static final BugReportService _instance = BugReportService._internal();

  factory BugReportService() => _instance;

  BugReportService._internal();

  final List<BugReport> _reports = [];

  List<BugReport> get reports => List.unmodifiable(_reports);

  Future<bool> submit({
    required String type,
    required String description,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _reports.add(
      BugReport(
        id: _reports.length + 1,
        type: type,
        description: description.trim(),
      ),
    );
    return true;
  }
}
