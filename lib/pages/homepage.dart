import 'package:flutter/material.dart';
import 'package:masrafi/pages/expenses_page.dart';
import 'package:masrafi/pages/incomes_page.dart';
import 'package:masrafi/pages/reports_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key, required this.userid}) : super(key: key);
  final int userid;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      ExpensesPage(userid: widget.userid),
      IncomePage(userid: widget.userid),
      ReportsPage(userID: widget.userid),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(child: pages.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_rounded),
            label: 'المصروفات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: 'الأيرادات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_rounded),
            label: 'التقارير',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
