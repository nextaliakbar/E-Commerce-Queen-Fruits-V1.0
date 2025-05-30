class ExpensesModel {
  final List<double> chartData;
  final List<String> periodLabels;
  final String month;
  final String year;
  final double totalAmount;

  ExpensesModel({
    required this.chartData,
    required this.periodLabels,
    required this.month,
    required this.year,
    required this.totalAmount
  });

  factory ExpensesModel.fromJson(Map<String, dynamic> json) {
    return ExpensesModel(
        chartData: json['chart_data'].map<double>((v) => double.parse(v.toString())).toList(),
        periodLabels: json['period_labels'].map<String>((v) => v.toString()).toList(),
        month: json['month'].toString(),
        year: json['year'].toString(),
        totalAmount: double.parse(json['total_amount'].toString())
    );
  }
}