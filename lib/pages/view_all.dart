import 'package:bankapp/db/bank_database.dart';
import 'package:bankapp/models/customer.dart';
import 'package:bankapp/pages/payment.dart';
import 'package:flutter/material.dart';

class ViewAllPage extends StatefulWidget {
  const ViewAllPage({Key? key}) : super(key: key);

  @override
  _ViewAllPageState createState() => _ViewAllPageState();
}

class _ViewAllPageState extends State<ViewAllPage> {
  late List<Customer> customers;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshCustomers();
  }

  @override
  void dispose() {
    // BankDatabase.instance.close();
    super.dispose();
  }

  Future refreshCustomers() async {
    setState(() {
      isLoading = true;
    });
    this.customers = await BankDatabase.instance.readAllCustomers();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "View All Customers",
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : customers.isEmpty
              ? Center(
                  child: Text(
                    "No Data 👀",
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : buildCustomers(),
    );
  }

  Widget buildCustomers() => SizedBox(
        width: double.infinity,
        child: InteractiveViewer(
          constrained: false,
          child: DataTable(
            showCheckboxColumn: false,
            columns: [
              DataColumn(label: Text("id")),
              DataColumn(label: Text("Name")),
              DataColumn(label: Text("Email")),
              DataColumn(label: Text("Current Balance")),
            ],
            rows: List<DataRow>.generate(
              customers.length,
              (index) => DataRow(
                  color: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (index.isEven) {
                      return Colors.grey.withOpacity(0.3);
                    }
                    return null; // Use default value for other states and odd rows.
                  }),
                  cells: [
                    DataCell(Text('${customers[index].id}')),
                    DataCell(Text('${customers[index].name}')),
                    DataCell(Text('${customers[index].email}')),
                    DataCell(Text('${customers[index].currentBalance}')),
                  ],
                  onSelectChanged: (v) async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          PaymentPage(customer: customers[index]),
                    ));
                    refreshCustomers();
                  }),
            ),
          ),
        ),
      );
}
