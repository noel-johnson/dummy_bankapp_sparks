import 'package:bankapp/pages/home.dart';
import 'package:bankapp/pages/transactions.dart';
import 'package:bankapp/pages/view_all.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BankApp',
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme().copyWith(
          centerTitle: true,
          // backgroundColor: Colors.grey.shade100,
          elevation: 0,
        ),
        // scaffoldBackgroundColor: Colors.grey.shade100,
        bottomNavigationBarTheme: BottomNavigationBarThemeData()
            .copyWith(selectedItemColor: Color(0xff4992ff)),
      ),
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme().copyWith(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Color(0xff0d6efd)),
        scaffoldBackgroundColor: Colors.grey.shade100,
        bottomNavigationBarTheme: BottomNavigationBarThemeData().copyWith(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xff0d6efd),
        ),
      ),
      home: BasePage(),
    );
  }
}

class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _index = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    ViewAllPage(),
    TransactionPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_index),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: (value) {
          setState(() {
            _index = value;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box), label: "View All"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet), label: "Transaction")
        ],
      ),
    );
  }
}
