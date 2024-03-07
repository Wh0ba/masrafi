import 'package:flutter/material.dart';
import 'package:masrafi/pages/expenses_page.dart';
import 'package:masrafi/pages/incomes_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key, required this.userid});
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Center(
            child: [
              ExpensesPage(
                userid: widget.userid,
              ),
              IncomePage(
                userid: widget.userid,
              ),
              const Text('Page 3')
            ].elementAt(_selectedIndex),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
