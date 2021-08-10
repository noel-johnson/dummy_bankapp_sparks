import 'package:bankapp/db/bank_database.dart';
import 'package:bankapp/models/transfers.dart';
import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late List<Transfers> tranfers;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshTranfers();
  }

  @override
  void dispose() {
    // BankDatabase.instance.close();
    super.dispose();
  }

  Future refreshTranfers() async {
    setState(() {
      isLoading = true;
    });
    this.tranfers = await BankDatabase.instance.readAllTransfers();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Transactions",
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : tranfers.isEmpty
              ? Center(
                  child: Text(
                    "No Data 👀",
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : buildTable(),
    );
  }

  Widget buildTable() => SizedBox(
        width: double.infinity,
        child: InteractiveViewer(
          constrained: false,
          child: DataTable(
            columns: [
              DataColumn(label: Text("id")),
              DataColumn(label: Text("Sender Name")),
              DataColumn(label: Text("Receiver Name")),
              DataColumn(label: Text("Amount")),
            ],
            rows: List<DataRow>.generate(
                tranfers.length,
                (index) => DataRow(
                        color: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                          // // All rows will have the same selected color.
                          // if (states.contains(MaterialState.selected)) {
                          //   return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                          // }
                          // Even rows will have a grey color.
                          if (index.isEven) {
                            return Colors.grey.withOpacity(0.3);
                          }
                          return null; // Use default value for other states and odd rows.
                        }),
                        cells: [
                          DataCell(Text('${tranfers[index].id}')),
                          DataCell(Text('${tranfers[index].senderName}')),
                          DataCell(Text('${tranfers[index].receiverName}')),
                          DataCell(Text('${tranfers[index].amount}')),
                        ])),
          ),
        ),
      );
}
