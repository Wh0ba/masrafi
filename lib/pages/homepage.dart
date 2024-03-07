import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:masrafi/handlers/db.dart';
import 'package:masrafi/models/m_category.dart';
import 'package:masrafi/models/m_transaction.dart';
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
          _selectedIndex != 2
              ? Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary),
                  margin: const EdgeInsets.only(top: 130),
                  child: ListTile(
                    title: const Text("النقود المتبقية",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: calculateMoney(),
                  ),
                )
              : Container(),
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

  Widget calculateMoney() {
    return FutureBuilder(
      future: DB.instance.getTransactions(widget.userid),
      initialData: const [],
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<MTransaction> data = List<MTransaction>.from(snapshot.data);
          num totalExpenses = data
              .where((element) => element.categoryID < 10)
              .fold(0,
                  (previousValue, element) => previousValue + element.amount);
          num totalIncome = data
              .where((element) => element.categoryID == MCategory.income.id)
              .fold(0,
                  (previousValue, element) => previousValue + element.amount);
          num total = totalIncome - totalExpenses;
          return Text('$total IQD', style: const TextStyle(fontSize: 18));
        } else {
          return const Text('0 IQD');
        }
      },
    );
  }
}
