import 'package:flutter/material.dart';
import 'package:masrafi/gateway/login_page.dart';
import 'package:masrafi/models/m_category.dart';
import 'package:masrafi/models/m_transaction.dart';
import 'package:masrafi/shared.dart';
import 'package:masrafi/widgets/add_item_dialog.dart';
import 'package:masrafi/widgets/item_list_widget.dart';
import 'package:masrafi/widgets/remining_money.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../handlers/db.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key, required this.userid});
  final int userid;

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> with TickerProviderStateMixin {
  int tabBarIndex = 0;
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(
        length: 2,
        vsync: this,
        animationDuration: const Duration(milliseconds: 200));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(actions: [
          IconButton(
            onPressed: () {
              SharedPreferences.getInstance().then((prefs) {
                prefs.remove(tokenKey);
              });
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage(),));
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        centerTitle: true,
        toolbarHeight: 80,
        title: const Text('ايراداتي'),
      ),
      body: FutureBuilder(
        future: DB.instance.getTransactions(widget.userid),
        initialData: const [],
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          List<MTransaction> data = List<MTransaction>.from(snapshot.data!);
          return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                remainingMoney(data),
                const Divider(),
                const Spacer(),
                SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 8),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 1.8,
                    child: ItemList(
                      placeholder: "أضف مصروف جديد",
                      items: data
                          .where((element) =>
                              element.categoryID == MCategory.income.id)
                          .toList(),
                      onRemove: (index) async {
                            await DB.instance.deleteTransaction(index);

                            setState(() {});
                          },
                    ),
                  ),
                ),
              ]);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () => addNewItemDialog(
              context: context,
              isExpense: false,
              callback: (name, amount, date, category) {
                DB.instance.addTransaction(
                    MTransaction(
                        name: name,
                        amount: amount,
                        date: date,
                        categoryID: category.id),
                    widget.userid);
                setState(() {});
              }),
          child: const Icon(Icons.add)),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
