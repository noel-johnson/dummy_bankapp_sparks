import 'package:bankapp/components/bankcard.dart';
import 'package:bankapp/db/bank_database.dart';
import 'package:bankapp/models/customer.dart';
import 'package:bankapp/models/transfers.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final Customer customer;
  PaymentPage({Key? key, required this.customer}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Customer customer;
  late List<Customer> customers;
  bool isLoading = false;
  late int? dropdownValue;
  int currentIndex = 0;
  TextEditingController textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    refreshCustomers();
  }

  Future refreshCustomers() async {
    setState(() {
      isLoading = true;
    });
    this.customer = widget.customer;
    this.customers =
        await BankDatabase.instance.readAllCustomers(id: widget.customer.id);
    this.dropdownValue = customers[0].id;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLoading ? "" : "Payment System for ${customer.name}"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : customers.isEmpty
              ? Center(
                  child: Text(
                    "No Data 👀",
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : buildPayment(),
    );
  }

  Widget buildPayment() => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BankCard(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 50, 80, 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${customer.name}'s",
                        style: TextStyle(fontSize: 24),
                      ),
                      Text(
                        "Current Balance: ${customer.currentBalance}",
                        style: TextStyle(fontSize: 21),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              BankCard(
                  child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 30, bottom: 30, right: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Customer",
                        style: TextStyle(fontSize: 22),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButton(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward_rounded),
                        iconSize: 24,
                        style: TextStyle(
                            fontSize: 19,
                            color: Theme.of(context).colorScheme.onSurface),
                        underline: Container(
                          height: 2,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onChanged: (int? newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: buildItems(),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Amount",
                        style: TextStyle(fontSize: 22),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              double.parse(value) > customer.currentBalance ||
                              double.parse(value) < 100) {
                            return "Enter a valid amount min:100 max: ${customer.currentBalance - 100}";
                          }
                          return null;
                        },
                        controller: textEditingController,
                        decoration: InputDecoration(
                          labelText: "Enter Amount",
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(
                              width: 2,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.60),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              width: 2,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).colorScheme.primary),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await updateCustomer(customer);
                            await updateCustomer(customers[currentIndex]);
                            await addTransfer();
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text("Transfer Money"),
                      )
                    ],
                  ),
                ),
              ))
            ],
          ),
        ),
      );
  // Future runTransaction() async {

  // }

  List<DropdownMenuItem<int>>? buildItems() => List.generate(
        customers.length,
        (index) => DropdownMenuItem(
          child: Text("${customers[index].name}"),
          value: customers[index].id,
          onTap: () {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      );

  Future updateCustomer(Customer? customerChange) async {
    Customer updateCustomer;
    if (customerChange == customer) {
      updateCustomer = customerChange!.copy(
          currentBalance: customerChange.currentBalance -
              double.parse(textEditingController.text));
    } else {
      updateCustomer = customerChange!.copy(
          currentBalance: customerChange.currentBalance +
              double.parse(textEditingController.text));
    }
    await BankDatabase.instance.update(updateCustomer);
  }

  Future addTransfer() async {
    final transfer = Transfers(
        senderName: customer.name,
        receiverName: customers[currentIndex].name,
        amount: double.parse(textEditingController.text),
        transferDate: DateTime.now());
    await BankDatabase.instance.create(transfer);
  }
}
