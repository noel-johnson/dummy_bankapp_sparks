import 'package:bankapp/db/bank_database.dart';
import 'package:bankapp/models/customer.dart';
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
    BankDatabase.instance.close();
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
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : customers.isEmpty
                ? Text(
                    "No Data 👀",
                    style: TextStyle(fontSize: 20),
                  )
                : buildCustomers(),
      ),
    );
  }

  Widget buildCustomers() => ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: customers.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(customers[index].name),
        ),
      );
}
