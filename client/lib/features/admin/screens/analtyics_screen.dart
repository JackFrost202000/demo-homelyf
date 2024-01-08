import 'package:homelyf_services/common/widgets/custom_button.dart';
import 'package:homelyf_services/common/widgets/loader.dart';
import 'package:homelyf_services/features/account/services/account_services.dart';
import 'package:homelyf_services/features/account/widgets/account_button.dart';
import 'package:homelyf_services/features/admin/models/sales.dart';
import 'package:homelyf_services/features/admin/services/admin_services.dart';
import 'package:homelyf_services/features/admin/widgets/category_products_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as charts;
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminServices adminServices = AdminServices();
  int? totalSales;
  List<Sales>? earnings;

  @override
  void initState() {
    super.initState();
    getEarnings();
  }

  getEarnings() async {
    var earningData = await adminServices.getEarnings(context);
    totalSales = earningData['totalEarnings'];
    earnings = earningData['sales'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return earnings == null || totalSales == null
        ? const Loader()
        : Column(
            children: [
              Text(
                '₹$totalSales',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // SizedBox(
              //   height: 250,
              //   child: CategoryProductsChart(seriesList: [
              //     charts.Series(
              //       id: 'Sales',
              //       data: earnings!,
              //       domainFn: (Sales sales, _) => sales.label,
              //       measureFn: (Sales sales, _) => sales.earning,
              //     ),
              //   ]),
              // ),
              SizedBox(
                width: 200,
                child: CustomButton(
                  text: 'Log Out',
                  onTap: () => AccountServices().logOut(context),
                  height: 30,
                ),
              ),
            ],
          );
  }
}
