import 'dart:convert' as convert;

class BugReport {
  int id;
  String type;
  String description;

  BugReport({
    required this.id,
    required this.type,
    required this.description,
  });

  factory BugReport.fromJson(Map<String, dynamic> json) => BugReport(
        id: json['id'],
        type: json['type'],
        description: json['description'],
      );

  static Map<String, String> toJson(BugReport report) => {
        'type': report.type,
        'description': report.description,
      };

  static String encode(List<BugReport> report) => convert.json.encode(
        report
            .map<Map<String, String>>((report) => BugReport.toJson(report))
            .toList(),
      );

  static List<BugReport> decode(String jsonString) =>
      (convert.json.decode(jsonString) as List<dynamic>)
          .map<BugReport>((report) => BugReport.fromJson(report))
          .toList();
}
